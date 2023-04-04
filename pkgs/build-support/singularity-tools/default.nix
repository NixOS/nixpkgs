{
  lib,
  stdenv,
  runCommand,
  vmTools,
  writeClosure,
  writeScript,
  writeShellScriptBin,
  e2fsprogs,
  util-linux,
  bash,
  runtimeShell,
  singularity,
}:

let
  defaultSingularity = singularity;
in
lib.makeExtensible (self: {
  buildSandboxFromContents =
    let
      shellScript =
        name: text:
        writeScript name ''
          #!${runtimeShell}
          set -e
          ${text}
        '';
    in
    {
      name,
      contents ? [ ],
      runScript ? "#!${stdenv.shell}\nexec /bin/sh",
      runAsRoot ? "",
      projectName ? defaultSingularity.projectName or "singularity",
    }:
    let
      layerClosure = writeClosure (
        contents
        ++ [
          bash
          runScriptFile
        ]
      );
      runAsRootFile = shellScript "run-as-root.sh" runAsRoot;
      runScriptFile = shellScript "run-script.sh" runScript;
      buildScriptBin = writeShellScriptBin "build-sandbox" ''
        if [ "$#" -lt 1 ]; then
          echo "Expect SANDBOX_PATH" >&2
          exit 1
        fi
        pathSandbox="$1"
        cd "$pathSandbox"
        mkdir proc sys dev

        ${lib.optionalString (runAsRoot != "") ''
          # Run root script
          mkdir -p ./${builtins.storeDir}
          mount --rbind ${builtins.storeDir} ./${builtins.storeDir}
          unshare -imnpuf --mount-proc chroot ./ ${runAsRootFile}
          umount -R ./${builtins.storeDir}
        ''}

        # Build /bin and copy across closure
        mkdir -p bin ./${builtins.storeDir}
        for f in $(cat ${layerClosure}) ; do
          cp -r $f ./$f
        done

        for c in ${lib.escapeShellArgs (map (s: "${s}") contents)} ; do
          for f in $c/bin/* ; do
            if [ ! -e bin/$(basename $f) ] ; then
              ln -s $f bin/
            fi
          done
        done

        # Create runScript and link shell
        if [ ! -e bin/sh ]; then
          ln -s ${runtimeShell} bin/sh
        fi
        mkdir -p .singularity.d
        ln -s ${runScriptFile} .singularity.d/runscript

        # Fill out .singularity.d
        mkdir -p .singularity.d/env
        touch .singularity.d/env/94-appsbase.sh
      '';
    in
    runCommand "${projectName}-sandbox-${name}"
      {
        passthru = {
          inherit
            buildScriptBin
            layerClosure
            projectName
            runAsRoot
            runScript
            ;
        };
      }
      ''
        runHook preImageBuild
        mkdir -p "$out"
        "${lib.getExe buildScriptBin}" "$out"
        runHook postImageBuild
      '';

  buildImageFromSandbox =
    {
      name,
      sandbox ? self.buildSandboxFromContents (
        builtins.intersectAttrs (lib.functionArgs self.buildSandboxFromContents) args
        // {
          name = "${name}-from-contents";
          projectName = singularity.projectName or "singularity";
        }
      ),
      # Whether to build the sandbox into a temporary path
      # with sandboxBuildScriptBin
      # and then build the image frem the temporary sandbox,
      # or to build the image directly from `"${sandbox}"`
      fromBuildScriptBin ? (sandbox ? buildScriptBin),
      singularity ? sandbox.singularity or defaultSingularity,
      # Placeholders for buildSandboxFromContents arguments
      contents ? null,
      runScript ? null,
      runAsRoot ? null,
      executableFlags ? null,
      buildImageFlags ? null,
    }@args:
    let
      projectName = singularity.projectName or sandbox.projectName or "singularity";
      inherit fromBuildScriptBin;
      buildScriptBin = writeShellScriptBin "build-image" ''
        if [ "$#" -lt 1 ]; then
          echo "Expect IMAGE_PATH" >&2
          exit 1
        fi
        pathSIF="$1"
        shift
          ${
            if fromBuildScriptBin then
              ''
                pathSandbox="$(mktemp -t -d sandbox_XXXXXX)"
                trap "rm -rf \"$pathSandbox\"" EXIT INT
                ${lib.escapeShellArg (lib.getExe sandbox.buildScriptBin)} "$pathSandbox"
              ''
            else
              ''
                pathSandbox=${lib.escapeShellArg "${sandbox}"}
              ''
          }
          ${projectName} build "$pathSIF" "$pathSandbox"
      '';
    in
    runCommand "${projectName}-image-${name}.sif"
      {
        buildInputs = [
          singularity
          util-linux
        ];
        passthru = sandbox.passthru or { } // {
          inherit
            buildScriptBin
            fromBuildScriptBin
            sandbox
            singularity
            projectName
            ;
        };
      }
      ''
        runHook preImageBuild
        ${lib.escapeShellArg "${lib.getExe buildScriptBin}"} "$out"
        runHook postImageBuild
      '';

  buildImageInLinuxVM =
    {
      diskSize ? 1024,
      memSize ? 512,
      preHookName ? "preImageBuild",
      postHookName ? "postImageBuild",
      # Note: Sylabs SingularityCE requires loop device to run images,
      # which is not available in the Nix build sandbox.
      supportImageRunning ? false,
      # For image running support
      localtime ? "UTC",
    }:
    drv:
    vmTools.runInLinuxVM (
      drv.overrideAttrs (
        finalAttrs: previousAttrs:
        {
          inherit supportImageRunning;
          nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [
            e2fsprogs
            util-linux
          ];
          preVM = vmTools.createEmptyImage {
            size = diskSize;
            fullName = "${finalAttrs.projectName}-run-disk";
          };
          projectName =
            previousAttrs.projectName or drv.projectName or drv.singularity.projectName
              or (throw "projectName not specified");
          externalLocalStateDir =
            previousAttrs.externalLocalStateDir or drv.singularity.externalLocalStateDir or "/var/lib";
          ${preHookName} = ''
            rm -rf $out
            mkdir disk
            mkfs -t ext4 -b 4096 /dev/${vmTools.hd}
            mount /dev/${vmTools.hd} disk
            if [[ -n "''${externalLocalStateDir-}" ]]; then
              mkdir -p "$externalLocalStateDir/$projectName/mnt/session"
            fi
            echo "root:x:0:0:System administrator:/root:/bin/sh" > /etc/passwd
            echo > /etc/resolv.conf
            TMPDIR="$(realpath disk)"; export TMPDIR
            if (( supportImageRunning )); then
              echo "root:x:0:"  > /etc/group
              echo "$localtime" > /etc/localtime
              mkdir -p /var/tmp
            fi
            cd disk
          '';
          passthru = {
            unprivileged-package = drv;
          };
        }
        // lib.optionalAttrs supportImageRunning { inherit localtime; }
      )
    );

  runImageInLinuxVM = lib.setFunctionArgs (
    {
      preHookName ? "preImageRun",
      postHookName ? "postImageRun",
      ...
    }@args:
    self.buildImageInLinuxVM (
      args
      // {
        inherit preHookName postHookName;
        supportImageRunning = true;
      }
    )
  ) (removeAttrs (lib.functionArgs self.buildImageInLinuxVM) [ "supportImageRunning" ]);

  buildImage =
    {
      name,
      contents ? [ ],
      diskSize ? 1024,
      runScript ? "#!${stdenv.shell}\nexec /bin/sh",
      runAsRoot ? "",
      memSize ? 1024,
      singularity ? defaultSingularity,
    }:
    self.buildImageInLinuxVM { inherit diskSize memSize; } (
      self.buildImageFromSandbox {
        inherit
          name
          contents
          runScript
          runAsRoot
          singularity
          ;
      }
    );
})

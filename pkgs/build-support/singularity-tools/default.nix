{ lib
, stdenv
, runCommand
, vmTools
, writeMultipleReferencesToFile
, writeScript
, writeShellScriptBin
, writeText
, e2fsprogs
, util-linux
, bash
, coreutils
, runtimeShell
, singularity
, storeDir ? builtins.storeDir
}:

let
  defaultSingularity = singularity;
in
rec {
  buildSandboxFromContents =
    let
      shellScript = name: text:
        writeScript name ''
          #!${runtimeShell}
          set -e
          ${text}
        '';
    in
    { name
    , contents ? [ ]
    , runScript ? "#!${stdenv.shell}\nexec /bin/sh"
    , runAsRoot ? null
    , projectName ? singularity.projectName or "singularity"
    }:
    let
      layerClosure = writeMultipleReferencesToFile (contents ++ [ bash runScriptFile ]);
      runAsRootFile = shellScript "run-as-root.sh" runAsRoot;
      runScriptFile = shellScript "run-script.sh" runScript;
      buildscriptPackage =
        writeShellScriptBin "build-sandbox"
          ''
            if [ "$#" -lt 1 ]; then
              echo "Expect SANDBOX_PATH" >&2
              exit 1
            fi
            pathSandbox="$1"
            cd "$pathSandbox"
            mkdir proc sys dev

            ${lib.optionalString (runAsRoot != null) ''
              # Run root script
              mkdir -p ./${storeDir}
              mount --rbind ${storeDir} ./${storeDir}
              unshare -imnpuf --mount-proc chroot ./ ${runAsRootFile}
              umount -R ./${storeDir}
            ''}

            # Build /bin and copy across closure
            mkdir -p bin ./${storeDir}
            for f in $(cat ${layerClosure}) ; do
              cp -r $f ./$f
            done

            for c in ${toString contents} ; do
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
            mkdir -p .${projectName}.d
            ln -s ${runScriptFile} .${projectName}.d/runscript

            # Fill out .${projectName}.d
            mkdir -p .${projectName}.d/env
            touch .${projectName}.d/env/94-appsbase.sh
          '';
    in
    runCommand "${projectName}-sandbox-${name}"
      {
        passthru = {
          inherit
            buildscriptPackage
            layerClosure
            projectName
            runAsRoot
            runScript
            ;
        };
      } ''
      runHook preImageBuild
      mkdir -p "$out"
      "${buildscriptPackage}/bin/${buildscriptPackage.meta.mainProgram}" "$out"
      runHook postImageBuild
    '';

  buildImageFromSandbox =
    { name
    , sandbox ? ""
    , contents ? [ ]
    , runScript ? "#!${stdenv.shell}\nexec /bin/sh"
    , runAsRoot ? null
    , singularity ? defaultSingularity
    , executableFlags ? [ ]
    , buildImageFlags ? [ ]
    }:
    let
      projectName = singularity.projectName or "singularity";
      sandboxFromContents = buildSandboxFromContents {
        name = "from-contents";
        inherit contents runScript runAsRoot projectName;
      };
      buildscriptPackage = writeShellScriptBin "build-image" ''
        if [ "$#" -lt 1 ]; then
          echo "Expect IMAGE_PATH" >&2
          exit 1
        fi
        pathSIF="$1"
        shift
          ${if sandbox != "" then ''
            pathSandbox=${sandbox}
          '' else ''
            pathSandbox="$(mktemp -t -d sandbox_XXXXXX)"
            trap "rm -rf \"$pathSandbox\"" EXIT INT
            "${sandboxFromContents.buildscriptPackage}/bin/${sandboxFromContents.buildscriptPackage.meta.mainProgram}" "$pathSandbox"
          ''}
          ${projectName} build "$pathSIF" "$pathSandbox"
      '';
    in
    runCommand "${projectName}-image-${name}.sif"
      {
        buildInputs = [ singularity util-linux ];
        passthru = {
          sandbox = if (sandbox != "") then sandbox else sandboxFromContents;
          layerClosure = if (sandbox != "") then sandbox.layerClosure else null;
          inherit singularity;
        };
      }
      ''
        runHook preImageBuild
        "${buildscriptPackage}/bin/${buildscriptPackage.meta.mainProgram}" "$out"
        runHook postImageBuild
      '';

  buildImageInLinuxVM =
    { diskSize ? 1024
    , memSize ? 512
    }:
    image:
    let
      projectName = image.projectName or image.singularity.projectName or "singularity";
    in
    vmTools.runInLinuxVM (image.overrideAttrs (prevAttrs: {
      buildInputs = prevAttrs.buildInputs or [ ] ++ [
        e2fsprogs
      ];
      preVM = vmTools.createEmptyImage {
        size = diskSize;
        fullName = "${projectName}-run-disk";
      };
      preImageBuild = ''
        rm -rf $out
        mkdir disk
        mkfs -t ext3 -b 4096 /dev/${vmTools.hd}
        mount /dev/${vmTools.hd} disk
        mkdir -p /var/lib/${projectName}/mnt/{container,final,overlay,session,source}
        echo "root:x:0:0:System administrator:/root:/bin/sh" > /etc/passwd
        echo > /etc/resolv.conf
        TMPDIR="$(realpath disk)"; export TMPDIR
        cd disk
      '';
    }));

  buildImage =
    { name
    , contents ? [ ]
    , diskSize ? 1024
    , runScript ? "#!${stdenv.shell}\nexec /bin/sh"
    , runAsRoot ? null
    , memSize ? 512
    , singularity ? defaultSingularity
    }:
    buildImageInLinuxVM
      {
        inherit diskSize memSize;
      }
      (buildImageFromSandbox {
        inherit name contents runScript runAsRoot singularity;
      });

  # shellScript = name: text:
  #   writeScript name ''
  #     #!${runtimeShell}
  #     set -e
  #     ${text}
  #   '';

  # buildImage =
  #   let
  #     defaultSingularity = singularity;
  #   in
  #   { name
  #   , contents ? [ ]
  #   , diskSize ? 1024
  #   , runScript ? "#!${stdenv.shell}\nexec /bin/sh"
  #   , runAsRoot ? null
  #   , memSize ? 512
  #   , singularity ? defaultSingularity
  #   }:
  #   let
  #     projectName = singularity.projectName or "singularity";
  #     runAsRootFile = shellScript "run-as-root.sh" runAsRoot;
  #     runScriptFile = shellScript "run-script.sh" runScript;
  #     result = vmTools.runInLinuxVM (
  #       runCommand "${projectName}-image-${name}.sif"
  #         {
  #           buildInputs = [ singularity e2fsprogs util-linux ];
  #           layerClosure = writeMultipleReferencesToFile (contents ++ [ bash runScriptFile ]);
  #           preVM = vmTools.createEmptyImage {
  #             size = diskSize;
  #             fullName = "${projectName}-run-disk";
  #           };
  #           inherit memSize;
  #         }
  #         ''
  #           rm -rf $out
  #           mkdir disk
  #           mkfs -t ext3 -b 4096 /dev/${vmTools.hd}
  #           mount /dev/${vmTools.hd} disk
  #           mkdir -p disk/img
  #           cd disk/img
  #           mkdir proc sys dev

  #           # Run root script
  #           ${lib.optionalString (runAsRoot != null) ''
  #             mkdir -p ./${storeDir}
  #             mount --rbind ${storeDir} ./${storeDir}
  #             unshare -imnpuf --mount-proc chroot ./ ${runAsRootFile}
  #             umount -R ./${storeDir}
  #           ''}

  #           # Build /bin and copy across closure
  #           mkdir -p bin ./${storeDir}
  #           for f in $(cat $layerClosure) ; do
  #             cp -ar $f ./$f
  #           done

  #           for c in ${toString contents} ; do
  #             for f in $c/bin/* ; do
  #               if [ ! -e bin/$(basename $f) ] ; then
  #                 ln -s $f bin/
  #               fi
  #             done
  #           done

  #           # Create runScript and link shell
  #           if [ ! -e bin/sh ]; then
  #             ln -s ${runtimeShell} bin/sh
  #           fi
  #           mkdir -p .${projectName}.d
  #           ln -s ${runScriptFile} .${projectName}.d/runscript

  #           # Fill out .${projectName}.d
  #           mkdir -p .${projectName}.d/env
  #           touch .${projectName}.d/env/94-appsbase.sh

  #           cd ..
  #           mkdir -p /var/lib/${projectName}/mnt/{container,final,overlay,session,source}
  #           echo "root:x:0:0:System administrator:/root:/bin/sh" > /etc/passwd
  #           echo > /etc/resolv.conf
  #           TMPDIR=$(pwd -P) ${projectName} build $out ./img
  #         '');

  #   in
  #   result;

  inherit (import ./definition-lib.nix { inherit lib; })
    knownPrimarySectionNamesDefault
    knownAppSectionNamesDefault
    toSingularityDef
    ;

  contentsToDef =
    { contents ? [ ]
    , definitionOverrider ? null
    }:
    let
      layerClosure = writeMultipleReferencesToFile (contents ++ [ bash coreutils ]);
    in
    (
      if lib.isFunction definitionOverrider then
        definitionOverrider
      else if builtins.isAttrs definitionOverrider then
        (d: lib.recursiveUpdate d definitionOverrider)
      else
        lib.id
    ) {
      header.Bootstrap = "scratch";
      setup = ''
        mkdir -p ''${SINGULARITY_ROOTFS}/${storeDir}
        for f in $(cat ${layerClosure}) ; do
          cp -r "$f" "''${SINGULARITY_ROOTFS}/${storeDir}"
        done
        mkdir -p "''${SINGULARITY_ROOTFS}/bin"
        "${coreutils}/bin/ln" -s "${runtimeShell}" "''${SINGULARITY_ROOTFS}/bin/sh"
        mkdir -p "''${SINGULARITY_ROOTFS}/usr/bin"
        "${coreutils}/bin/ln" -s "${coreutils}/bin/env" "''${SINGULARITY_ROOTFS}/usr/bin/env"
      '';
      environment = {
        PATH = "${lib.makeBinPath contents}:\${PATH:-}";
      };
      labels = {
        inherit layerClosure;
      };
    };

  buildImageFromDef =
    args@{ name
    , definition ? contentsToDef { inherit contents definitionOverrider; }
    , contents ? [ ]
    , definitionOverrider ? null
    , executableFlags ? [ ]
    , buildImageFlags ? [ ]
    , singularity ? defaultSingularity
    , toSingularityDefArgs ? { }
    , ...
    }:
    let
      # May be "apptainer" instead of "singularity"
      projectName = singularity.projectName or "singularity";
      definitionFile = writeText "${name}.def" (toSingularityDef toSingularityDefArgs definition);
      # Pass for users who want to build from the command line instead of inside a VM.
      buildscriptPackage = writeShellScriptBin "build-image" ''
        if [ "$#" -lt 1 ]; then
          echo "Expect IMAGE_PATH" >&2
          exit 1
        fi
        pathSIF="$1"
        shift
        ${lib.toUpper projectName}ENV_PATH="$PATH" "${singularity}/bin/${projectName}" ${toString executableFlags} build ${toString buildImageFlags} "$@" "$pathSIF" "${definitionFile}"
      '';
    in
    (runCommand "${projectName}-image-${name}.sif"
      (removeAttrs args [ "name" "contents" "definition" "definitionOverrider" ] // {
        inherit executableFlags buildImageFlags;
        passthru = args.passthru or { } // {
          inherit singularity definition definitionFile buildscriptPackage;
          layerClosure = definition.labels.layerClosure or null;
        };
      }) ''
      "${buildscriptPackage}/bin/${buildscriptPackage.meta.mainProgram}" "$out" $buildImageFlags "''${buildImageFlagsArray[@]}"
    '');
}

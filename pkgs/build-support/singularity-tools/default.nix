{
  lib,
  # Build helpers
  stdenv,
  runCommand,
  vmTools,
  writeClosure,
  writeDirectReferencesToFile,
  writeScript,
  writeStringReferencesToFile,
  # Native build inputs
  buildPackages,
  e2fsprogs,
  util-linux,
  # Build inputs
  bashInteractive,
  runtimeShell,
  singularity,
}:

let
  defaultSingularity = singularity;
in
lib.makeExtensible (final: {
  # TODO(@ShamrockLee): Remove after Nixpkgs 24.11 branch-off.
  shellScript =
    lib.warn
      "`singularity-tools.shellScript` is deprecated. Use `writeScript`, `writeShellScripts` or `writers.writeBash` instead."
      (
        name: text:
        writeScript name ''
          #!${runtimeShell}
          set -e
          ${text}
        ''
      );

  # TODO(@ShamrockLee): Remove after Nixpkgs 24.11 branch-off.
  mkLayer =
    lib.warn
      "`singularity-tools.mkLayer` is deprecated, as it is no longer used to implement `singularity-tools.buildImages`."
      (
        {
          name,
          contents ? [ ],
          # May be "apptainer" instead of "singularity"
          projectName ? (singularity.projectName or "singularity"),
        }:
        runCommand "${projectName}-layer-${name}" { inherit contents; } ''
          mkdir $out
          for f in $contents ; do
            cp -ra $f $out/
          done
        ''
      );

  buildImage =
    {
      name,
      contents ? [ ],
      diskSize ? 1024,
      memSize ? 1024,
      runAsRoot ? null,
      runScript ? "#!${stdenv.shell}\nexec /bin/sh",
      singularity ? defaultSingularity,
    }:
    let
      projectName = singularity.projectName or "singularity";
      runAsRootFile = buildPackages.writers.writeBash "run-as-root.sh" ''
        set -e
        ${runAsRoot}
      '';
      runScriptFile = writeScript "run-script.sh" ''
        #!/bin/sh
        set -e
        ${runScript}
      '';
      runScriptReferences =
        if builtins ? getContext then
          lib.splitString "\n" (writeStringReferencesToFile runScriptFile.text).text
        else
          [ (writeDirectReferencesToFile runScriptFile) ];
      result = vmTools.runInLinuxVM (
        runCommand "${projectName}-image-${name}.sif"
          {
            nativeBuildInputs = [
              singularity
              e2fsprogs
              util-linux
            ];
            strictDeps = true;
            layerClosure = writeClosure ([ bashInteractive ] ++ runScriptReferences ++ contents);
            preVM = vmTools.createEmptyImage {
              size = diskSize;
              fullName = "${projectName}-run-disk";
              # Leaving "$out" for the Singularity/Container image
              destination = "disk-image";
            };
            inherit memSize;
          }
          ''
            rmdir "$out"
            mkdir workspace
            mkfs -t ext3 -b 4096 /dev/${vmTools.hd}
            mount /dev/${vmTools.hd} workspace
            mkdir -p workspace/img
            cd workspace/img
            mkdir proc sys dev

            # Run root script
            ${lib.optionalString (runAsRoot != null) ''
              mkdir -p ./${builtins.storeDir}
              mount --rbind "${builtins.storeDir}" ./${builtins.storeDir}
              unshare -imnpuf --mount-proc chroot ./ ${runAsRootFile}
              umount -R ./${builtins.storeDir}
            ''}

            # Build /bin and copy across closure
            mkdir -p bin ./${builtins.storeDir}
            # Loop over the line-separated paths in $layerClosure
            while IFS= read -r f; do
              cp -r "$f" "./$f"
            done < "$layerClosure"

            # TODO(@ShamrockLee):
            # Once vmTools.runInLinuxVMm works with `__structuredAttrs = true` (#334705),
            # set __structuredAttrs = true and pass contents as an attribute
            # so that we could loop with `for c in ''${contents[@]}`
            # instead of expanding all the paths in contents into the Bash string.
            for c in ${lib.escapeShellArgs contents} ; do
              for f in "$c"/bin/* ; do
                if [ ! -e "bin/$(basename "$f")" ] ; then
                  ln -s "$f" bin/
                fi
              done
            done

            # Link /bin/sh
            if [ ! -e bin/sh ]; then
              ln -s ${lib.getExe bashInteractive} bin/sh
            fi
            mkdir -p .singularity.d

            # Create runscript
            cp "${runScriptFile}" .singularity.d/runscript

            # Fill out .singularity.d
            mkdir -p .singularity.d/env
            touch .singularity.d/env/94-appsbase.sh

            cd ..
            mkdir -p /var/lib/${projectName}/mnt/session
            echo "root:x:0:0:System administrator:/root:/bin/sh" > /etc/passwd
            echo > /etc/resolv.conf
            TMPDIR="$(pwd -P)" ${projectName} build "$out" ./img
          ''
      );

    in
    result;
})

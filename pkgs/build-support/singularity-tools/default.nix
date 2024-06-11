{ runCommand
, lib
, stdenv
, storeDir ? builtins.storeDir
, writeScript
, singularity
, writeClosure
, bash
, vmTools
, gawk
, util-linux
, runtimeShell
, e2fsprogs
}:
rec {
  shellScript = name: text:
    writeScript name ''
      #!${runtimeShell}
      set -e
      ${text}
    '';

  mkLayer =
    { name
    , contents ? [ ]
      # May be "apptainer" instead of "singularity"
    , projectName ? (singularity.projectName or "singularity")
    }:
    runCommand "${projectName}-layer-${name}"
      {
        inherit contents;
      } ''
      mkdir $out
      for f in $contents ; do
        cp -ra $f $out/
      done
    '';

  buildImage =
    let
      defaultSingularity = singularity;
    in
    { name
    , contents ? [ ]
    , diskSize ? 1024
    , runScript ? "#!${stdenv.shell}\nexec /bin/sh"
    , runAsRoot ? null
    , memSize ? 1024
    , singularity ? defaultSingularity
    }:
    let
      projectName = singularity.projectName or "singularity";
      runAsRootFile = shellScript "run-as-root.sh" runAsRoot;
      runScriptFile = shellScript "run-script.sh" runScript;
      result = vmTools.runInLinuxVM (
        runCommand "${projectName}-image-${name}.img"
          {
            buildInputs = [ singularity e2fsprogs util-linux gawk ];
            layerClosure = writeClosure contents;
            preVM = vmTools.createEmptyImage {
              size = diskSize;
              fullName = "${projectName}-run-disk";
            };
            inherit memSize;
          }
          ''
            rm -rf $out
            mkdir disk
            mkfs -t ext3 -b 4096 /dev/${vmTools.hd}
            mount /dev/${vmTools.hd} disk
            mkdir -p disk/img
            cd disk/img
            mkdir proc sys dev

            # Run root script
            ${lib.optionalString (runAsRoot != null) ''
              mkdir -p ./${storeDir}
              mount --rbind ${storeDir} ./${storeDir}
              unshare -imnpuf --mount-proc chroot ./ ${runAsRootFile}
              umount -R ./${storeDir}
            ''}

            # Build /bin and copy across closure
            mkdir -p bin ./${builtins.storeDir}
            for f in $(cat $layerClosure) ; do
              cp -ar $f ./$f
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

            cd ..
            mkdir -p /var/lib/${projectName}/mnt/session
            echo "root:x:0:0:System administrator:/root:/bin/sh" > /etc/passwd
            echo > /etc/resolv.conf
            TMPDIR=$(pwd -P) ${projectName} build $out ./img
          '');

    in
    result;
}

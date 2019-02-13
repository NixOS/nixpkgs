{ runCommand
, stdenv
, storeDir ? builtins.storeDir
, writeScript
, singularity
, writeReferencesToFile
, bash
, vmTools
, gawk
, utillinux
, e2fsprogs }:

rec {
  shellScript = name: text:
    writeScript name ''
      #!${stdenv.shell}
      set -e
      ${text}
    '';

  mkLayer = {
    name,
    contents ? [],
  }:
    runCommand "singularity-layer-${name}" {
      inherit contents;
    } ''
      mkdir $out
      for f in $contents ; do
        cp -ra $f $out/
      done
    '';

  buildImage = {
    name,
    contents ? [],
    diskSize ? 1024,
    runScript ? "#!${stdenv.shell}\nexec /bin/sh",
    runAsRoot ? null,
    extraSpace ? 0
  }:
    let layer = mkLayer {
          inherit name;
          contents = contents ++ [ bash runScriptFile ];
          };
        runAsRootFile = shellScript "run-as-root.sh" runAsRoot;
        runScriptFile = shellScript "run-script.sh" runScript;
        result = vmTools.runInLinuxVM (
          runCommand "singularity-image-${name}.img" {
            buildInputs = [ singularity e2fsprogs utillinux gawk ];
            layerClosure = writeReferencesToFile layer;
            preVM = vmTools.createEmptyImage {
              size = diskSize;
              fullName = "singularity-run-disk";
            };
          }
          ''
            rm -rf $out
            mkdir disk
            mkfs -t ext3 -b 4096 /dev/${vmTools.hd}
            mount /dev/${vmTools.hd} disk
            cd disk
            mkdir proc sys dev

            # Run root script
            ${stdenv.lib.optionalString (runAsRoot != null) ''
              mkdir -p ./${storeDir}
              mount --rbind ${storeDir} ./${storeDir}
              unshare -imnpuf --mount-proc chroot ./ ${runAsRootFile}
              umount -R ./${storeDir}
            ''}

            # Build /bin and copy across closure
            mkdir -p bin nix/store
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

            # Create runScript
            ln -s ${runScriptFile} singularity

            # Size calculation
            cd ..
            umount disk
            size=$(resize2fs -P /dev/${vmTools.hd} | awk '{print $NF}')
            mount /dev/${vmTools.hd} disk
            cd disk

            export PATH=$PATH:${e2fsprogs}/bin/
            echo creating
            singularity image.create -s $((1 + size * 4 / 1024 + ${toString extraSpace})) $out
            echo importing
            mkdir -p /var/singularity/mnt/{container,final,overlay,session,source}
            tar -c . | singularity image.import $out
          '');

    in result;
}

{ stdenv, lib, callPackage, runCommand, writeReferencesToFile, writeText, vmTools, writeScript
, docker, shadow, utillinux, coreutils, jshon, e2fsprogs, goPackages, pigz }:

# WARNING: this API is unstable and may be subject to backwards-incompatible changes in the future.
  
rec {

  pullImage = callPackage ./pull.nix {};
  
  # We need to sum layer.tar, not a directory, hence tarsum instead of nix-hash.
  # And we cannot untar it, because then we cannot preserve permissions ecc.
  tarsum = runCommand "tarsum" {
    buildInputs = [ goPackages.go ];
  } ''
    mkdir tarsum
    cd tarsum

    cp ${./tarsum.go} tarsum.go
    export GOPATH=$(pwd)
    mkdir src
    ln -sT ${docker.src}/pkg/tarsum src/tarsum
    go build

    cp tarsum $out
  '';
  
  # buildEnv creates symlinks to dirs, which is hard to edit inside the overlay VM
  mergeDrvs = { drvs, onlyDeps ? false }:
    runCommand "merge-drvs" {
      inherit drvs onlyDeps;
    } ''
      if [ -n "$onlyDeps" ]; then
        echo $drvs > $out
        exit 0
      fi
        
      mkdir $out
      for drv in $drvs; do
        echo Merging $drv
        if [ -d "$drv" ]; then
          cp -drf --preserve=mode -f $drv/* $out/
        else
          tar -C $out -xpf $drv || true
        fi
      done
    '';
  
  shellScript = text:
    writeScript "script.sh" ''
      #!${stdenv.shell}
      set -e
      export PATH=${coreutils}/bin:/bin

      ${text}
    '';

  shadowSetup = ''
    export PATH=${shadow}/bin:$PATH
    mkdir -p /etc/pam.d
    if [ ! -f /etc/passwd ]; then
      echo "root:x:0:0::/root:/bin/sh" > /etc/passwd
      echo "root:!x:::::::" > /etc/shadow
    fi
    if [ ! -f /etc/group ]; then
      echo "root:x:0:" > /etc/group
      echo "root:x::" > /etc/gshadow
    fi
    if [ ! -f /etc/pam.d/other ]; then
      cat > /etc/pam.d/other <<EOF
account sufficient pam_unix.so
auth sufficient pam_rootok.so
password requisite pam_unix.so nullok sha512
session required pam_unix.so
EOF
    fi
    if [ ! -f /etc/login.defs ]; then
      touch /etc/login.defs
    fi
  '';

  runWithOverlay = { name , fromImage ? null, fromImageName ? null, fromImageTag ? null
                   , diskSize ? 1024, preMount ? "", postMount ? "", postUmount ? "" }:
    vmTools.runInLinuxVM (
      runCommand name {
        preVM = vmTools.createEmptyImage { size = diskSize; fullName = "docker-run-disk"; };

        inherit fromImage fromImageName fromImageTag;
        
        buildInputs = [ utillinux e2fsprogs jshon ];
      } ''
      rm -rf $out
      
      mkdir disk
      mkfs /dev/${vmTools.hd}
      mount /dev/${vmTools.hd} disk
      cd disk

      if [ -n "$fromImage" ]; then
        echo Unpacking base image
        mkdir image
        tar -C image -xpf "$fromImage"

        if [ -z "$fromImageName" ]; then
          fromImageName=$(jshon -k < image/repositories|head -n1)
        fi
        if [ -z "$fromImageTag" ]; then
          fromImageTag=$(jshon -e $fromImageName -k < image/repositories|head -n1)
        fi
        parentID=$(jshon -e $fromImageName -e $fromImageTag -u < image/repositories)
      fi

      lowerdir=""
      while [ -n "$parentID" ]; do
        echo Unpacking layer $parentID
        mkdir -p image/$parentID/layer
        tar -C image/$parentID/layer -xpf image/$parentID/layer.tar
        rm image/$parentID/layer.tar

        find image/$parentID/layer -name ".wh.*" -exec bash -c 'name="$(basename {}|sed "s/^.wh.//")"; mknod "$(dirname {})/$name" c 0 0; rm {}' \;

        lowerdir=$lowerdir''${lowerdir:+:}image/$parentID/layer
        parentID=$(cat image/$parentID/json|(jshon -e parent -u 2>/dev/null || true))
      done

      mkdir work
      mkdir layer
      mkdir mnt

      ${preMount}

      if [ -n "$lowerdir" ]; then
        mount -t overlay overlay -olowerdir=$lowerdir,workdir=work,upperdir=layer mnt
      else
        mount --bind layer mnt
      fi

      ${postMount}
 
      umount mnt

      pushd layer
      find . -type c -exec bash -c 'name="$(basename {})"; touch "$(dirname {})/.wh.$name"; rm "{}"' \;
      popd

      ${postUmount}
      '');

  exportImage = { name ? fromImage.name, fromImage, fromImageName ? null, fromImageTag ? null, diskSize ? 1024 }:
    runWithOverlay {
      inherit name fromImage fromImageName fromImageTag diskSize;

      postMount = ''
        echo Packing raw image
        tar -C mnt -cf $out .
      '';
    };
    
  mkPureLayer = { baseJson, contents ? null, extraCommands ? "" }:
    runCommand "docker-layer" {
      inherit baseJson contents extraCommands;

      buildInputs = [ jshon ];
    } ''
      mkdir layer
      if [ -n "$contents" ]; then
        echo Adding contents
        for c in $contents; do
          cp -drf $c/* layer/
          chmod -R ug+w layer/
        done
      fi

      pushd layer
      ${extraCommands}
      popd
      
      echo Packing layer
      mkdir $out
      tar -C layer -cf $out/layer.tar .
      ts=$(${tarsum} < $out/layer.tar)
      cat ${baseJson} | jshon -s "$ts" -i checksum > $out/json
      echo -n "1.0" > $out/VERSION
    '';

  mkRootLayer = { runAsRoot, baseJson, fromImage ? null, fromImageName ? null, fromImageTag ? null
                , diskSize ? 1024, contents ? null, extraCommands ? "" }:
    let runAsRootScript = writeScript "run-as-root.sh" runAsRoot;
    in runWithOverlay {
      name = "docker-layer";
      
      inherit fromImage fromImageName fromImageTag diskSize;

      preMount = lib.optionalString (contents != null) ''
        echo Adding contents
        for c in ${builtins.toString contents}; do
          cp -drf $c/* layer/
          chmod -R ug+w layer/
        done
      '';

      postMount = ''
        mkdir -p mnt/{dev,proc,sys,nix/store}
        mount --rbind /dev mnt/dev
        mount --rbind /sys mnt/sys
        mount --rbind /nix/store mnt/nix/store

        unshare -imnpuf --mount-proc chroot mnt ${runAsRootScript}
        umount -R mnt/dev mnt/sys mnt/nix/store
        rmdir --ignore-fail-on-non-empty mnt/dev mnt/proc mnt/sys mnt/nix/store mnt/nix
      '';
 
      postUmount = ''
        pushd layer
        ${extraCommands}
        popd

        echo Packing layer
        mkdir $out
        tar -C layer -cf $out/layer.tar .
        ts=$(${tarsum} < $out/layer.tar)
        cat ${baseJson} | jshon -s "$ts" -i checksum > $out/json
        echo -n "1.0" > $out/VERSION
      '';
    };

  # 1. extract the base image
  # 2. create the layer
  # 3. add layer deps to the layer itself, diffing with the base image
  # 4. compute the layer id
  # 5. put the layer in the image
  # 6. repack the image
  buildImage = args@{ name, tag ? "latest"
               , fromImage ? null, fromImageName ? null, fromImageTag ? null
               , contents ? null, config ? null, runAsRoot ? null
               , diskSize ? 1024, extraCommands ? "" }:

    let

      baseName = baseNameOf name;

      baseJson = writeText "${baseName}-config.json" (builtins.toJSON {
          created = "1970-01-01T00:00:01Z";
          architecture = "amd64";
          os = "linux";
          config = config;
      });

      layer = (if runAsRoot == null
               then mkPureLayer { inherit baseJson contents extraCommands; }
               else mkRootLayer { inherit baseJson fromImage fromImageName fromImageTag contents runAsRoot diskSize extraCommands; });
      result = runCommand "${baseName}.tar.gz" {
        buildInputs = [ jshon pigz ];

        imageName = name;
        imageTag = tag;
        inherit fromImage baseJson;

        layerClosure = writeReferencesToFile layer;

        passthru = {
          buildArgs = args;
        };
      } ''
        mkdir image
        touch baseFiles
        if [ -n "$fromImage" ]; then
          echo Unpacking base image
          tar -C image -xpf "$fromImage"
          
          if [ -z "$fromImageName" ]; then
            fromImageName=$(jshon -k < image/repositories|head -n1)
          fi
          if [ -z "$fromImageTag" ]; then
            fromImageTag=$(jshon -e $fromImageName -k < image/repositories|head -n1)
          fi
          parentID=$(jshon -e $fromImageName -e $fromImageTag -u < image/repositories)
          
          for l in image/*/layer.tar; do
            tar -tf $l >> baseFiles
          done
        fi

        chmod -R ug+rw image
        
        mkdir temp
        cp ${layer}/* temp/
        chmod ug+w temp/*

        touch layerFiles
        for dep in $(cat $layerClosure); do
          find $dep >> layerFiles
        done

        echo Adding layer
        tar -tf temp/layer.tar >> baseFiles
        comm <(sort -n baseFiles|uniq) <(sort -n layerFiles|uniq|grep -v ${layer}) -1 -3 > newFiles
        tar -rpf temp/layer.tar --no-recursion --files-from newFiles 2>/dev/null || true

        echo Adding meta
        
        if [ -n "$parentID" ]; then
          cat temp/json | jshon -s "$parentID" -i parent > tmpjson
          mv tmpjson temp/json
        fi
        
        layerID=$(sha256sum temp/json|cut -d ' ' -f 1)
        size=$(stat --printf="%s" temp/layer.tar)
        cat temp/json | jshon -s "$layerID" -i id -n $size -i Size > tmpjson
        mv tmpjson temp/json

        mv temp image/$layerID
        
        jshon -n object \
          -n object -s "$layerID" -i "$imageTag" \
          -i "$imageName" > image/repositories

        chmod -R a-w image

        echo Cooking the image
        tar -C image -c . | pigz > $out
      '';

    in

      result;

}

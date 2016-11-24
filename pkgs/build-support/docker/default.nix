{
  callPackage,
  coreutils,
  docker,
  e2fsprogs,
  findutils,
  go,
  jshon,
  lib,
  pkgs,
  pigz,
  runCommand,
  rsync,
  shadow,
  stdenv,
  storeDir ? builtins.storeDir,
  utillinux,
  vmTools,
  writeReferencesToFile,
  writeScript,
  writeText,
}:

# WARNING: this API is unstable and may be subject to backwards-incompatible changes in the future.

rec {

  examples = import ./examples.nix {
    inherit pkgs buildImage pullImage shadowSetup;
  };

  pullImage = callPackage ./pull.nix {};

  # We need to sum layer.tar, not a directory, hence tarsum instead of nix-hash.
  # And we cannot untar it, because then we cannot preserve permissions ecc.
  tarsum = runCommand "tarsum" {
    buildInputs = [ go ];
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
  mergeDrvs = {
    derivations,
    onlyDeps ? false
  }:
    runCommand "merge-drvs" {
      inherit derivations onlyDeps;
    } ''
      if [[ -n "$onlyDeps" ]]; then
        echo $derivations > $out
        exit 0
      fi

      mkdir $out
      for derivation in $derivations; do
        echo "Merging $derivation..."
        if [[ -d "$derivation" ]]; then
          # If it's a directory, copy all of its contents into $out.
          cp -drf --preserve=mode -f $derivation/* $out/
        else
          # Otherwise treat the derivation as a tarball and extract it
          # into $out.
          tar -C $out -xpf $drv || true
        fi
      done
    '';

  # Helper for setting up the base files for managing users and
  # groups, only if such files don't exist already. It is suitable for
  # being used in a runAsRoot script.
  shadowSetup = ''
    export PATH=${shadow}/bin:$PATH
    mkdir -p /etc/pam.d
    if [[ ! -f /etc/passwd ]]; then
      echo "root:x:0:0::/root:/bin/sh" > /etc/passwd
      echo "root:!x:::::::" > /etc/shadow
    fi
    if [[ ! -f /etc/group ]]; then
      echo "root:x:0:" > /etc/group
      echo "root:x::" > /etc/gshadow
    fi
    if [[ ! -f /etc/pam.d/other ]]; then
      cat > /etc/pam.d/other <<EOF
    account sufficient pam_unix.so
    auth sufficient pam_rootok.so
    password requisite pam_unix.so nullok sha512
    session required pam_unix.so
    EOF
    fi
    if [[ ! -f /etc/login.defs ]]; then
      touch /etc/login.defs
    fi
  '';

  # Run commands in a virtual machine.
  runWithOverlay = {
    name,
    fromImage ? null,
    fromImageName ? null,
    fromImageTag ? null,
    diskSize ? 1024,
    preMount ? "",
    postMount ? "",
    postUmount ? ""
  }:
    vmTools.runInLinuxVM (
      runCommand name {
        preVM = vmTools.createEmptyImage {
          size = diskSize;
          fullName = "docker-run-disk";
        };
        inherit fromImage fromImageName fromImageTag;

        buildInputs = [ utillinux e2fsprogs jshon rsync ];
      } ''
      rm -rf $out

      mkdir disk
      mkfs /dev/${vmTools.hd}
      mount /dev/${vmTools.hd} disk
      cd disk

      if [[ -n "$fromImage" ]]; then
        echo "Unpacking base image..."
        mkdir image
        tar -C image -xpf "$fromImage"

        # If the image name isn't set, read it from the image repository json.
        if [[ -z "$fromImageName" ]]; then
          fromImageName=$(jshon -k < image/repositories | head -n 1)
          echo "From-image name wasn't set. Read $fromImageName."
        fi

        # If the tag isn't set, use the name as an index into the json
        # and read the first key found.
        if [[ -z "$fromImageTag" ]]; then
          fromImageTag=$(jshon -e $fromImageName -k < image/repositories \
                         | head -n1)
          echo "From-image tag wasn't set. Read $fromImageTag."
        fi

        # Use the name and tag to get the parent ID field.
        parentID=$(jshon -e $fromImageName -e $fromImageTag -u \
                   < image/repositories)
      fi

      # Unpack all of the parent layers into the image.
      lowerdir=""
      while [[ -n "$parentID" ]]; do
        echo "Unpacking layer $parentID"
        mkdir -p image/$parentID/layer
        tar -C image/$parentID/layer -xpf image/$parentID/layer.tar
        rm image/$parentID/layer.tar

        find image/$parentID/layer -name ".wh.*" -exec bash -c 'name="$(basename {}|sed "s/^.wh.//")"; mknod "$(dirname {})/$name" c 0 0; rm {}' \;

        # Get the next lower directory and continue the loop.
        lowerdir=$lowerdir''${lowerdir:+:}image/$parentID/layer
        parentID=$(cat image/$parentID/json \
                  | (jshon -e parent -u 2>/dev/null || true))
      done

      mkdir work
      mkdir layer
      mkdir mnt

      ${lib.optionalString (preMount != "") ''
        # Execute pre-mount steps
        echo "Executing pre-mount steps..."
        ${preMount}
      ''}

      if [ -n "$lowerdir" ]; then
        mount -t overlay overlay -olowerdir=$lowerdir,workdir=work,upperdir=layer mnt
      else
        mount --bind layer mnt
      fi

      ${lib.optionalString (postMount != "") ''
        # Execute post-mount steps
        echo "Executing post-mount steps..."
        ${postMount}
      ''}

      umount mnt

      (
        cd layer
        cmd='name="$(basename {})"; touch "$(dirname {})/.wh.$name"; rm "{}"'
        find . -type c -exec bash -c "$cmd" \;
      )

      ${postUmount}
      '');

  exportImage = { name ? fromImage.name, fromImage, fromImageName ? null, fromImageTag ? null, diskSize ? 1024 }:
    runWithOverlay {
      inherit name fromImage fromImageName fromImageTag diskSize;

      postMount = ''
        echo "Packing raw image..."
        tar -C mnt --mtime=0 -cf $out .
      '';
    };


  # Create an executable shell script which has the coreutils in its
  # PATH. Since root scripts are executed in a blank environment, even
  # things like `ls` or `echo` will be missing.
  shellScript = name: text:
    writeScript name ''
      #!${stdenv.shell}
      set -e
      export PATH=${coreutils}/bin:/bin
      ${text}
    '';

  # Create a "layer" (set of files).
  mkPureLayer = {
    # Name of the layer
    name,
    # JSON containing configuration and metadata for this layer.
    baseJson,
    # Files to add to the layer.
    contents ? null,
    # Additional commands to run on the layer before it is tar'd up.
    extraCommands ? ""
  }:
    runCommand "docker-layer-${name}" {
      inherit baseJson contents extraCommands;

      buildInputs = [ jshon rsync ];
    }
    ''
      mkdir layer
      if [[ -n "$contents" ]]; then
        echo "Adding contents..."
        for item in $contents; do
          echo "Adding $item"
          rsync -ak $item/ layer/
        done
      else
        echo "No contents to add to layer."
      fi

      if [[ -n $extraCommands ]]; then
        (cd layer; eval "$extraCommands")
      fi

      # Tar up the layer and throw it into 'layer.tar'.
      echo "Packing layer..."
      mkdir $out
      tar -C layer --mtime=0 -cf $out/layer.tar .

      # Compute a checksum of the tarball.
      echo "Computing layer checksum..."
      tarsum=$(${tarsum} < $out/layer.tar)

      # Add a 'checksum' field to the JSON, with the value set to the
      # checksum of the tarball.
      cat ${baseJson} | jshon -s "$tarsum" -i checksum > $out/json

      # Indicate to docker that we're using schema version 1.0.
      echo -n "1.0" > $out/VERSION

      echo "Finished building layer '${name}'"
    '';

  # Make a "root" layer; required if we need to execute commands as a
  # privileged user on the image. The commands themselves will be
  # performed in a virtual machine sandbox.
  mkRootLayer = {
    # Name of the image.
    name,
    # Script to run as root. Bash.
    runAsRoot,
    # Files to add to the layer. If null, an empty layer will be created.
    contents ? null,
    # JSON containing configuration and metadata for this layer.
    baseJson,
    # Existing image onto which to append the new layer.
    fromImage ? null,
    # Name of the image we're appending onto.
    fromImageName ? null,
    # Tag of the image we're appending onto.
    fromImageTag ? null,
    # How much disk to allocate for the temporary virtual machine.
    diskSize ? 1024,
    # Commands (bash) to run on the layer; these do not require sudo.
    extraCommands ? ""
  }:
    # Generate an executable script from the `runAsRoot` text.
    let runAsRootScript = shellScript "run-as-root.sh" runAsRoot;
    in runWithOverlay {
      name = "docker-layer-${name}";

      inherit fromImage fromImageName fromImageTag diskSize;

      preMount = lib.optionalString (contents != null && contents != []) ''
        echo "Adding contents..."
        for item in ${toString contents}; do
          echo "Adding $item..."
          rsync -ak $item/ layer/
        done
      '';

      postMount = ''
        mkdir -p mnt/{dev,proc,sys} mnt${storeDir}

        # Mount /dev, /sys and the nix store as shared folders.
        mount --rbind /dev mnt/dev
        mount --rbind /sys mnt/sys
        mount --rbind ${storeDir} mnt${storeDir}

        # Execute the run as root script. See 'man unshare' for
        # details on what's going on here; basically this command
        # means that the runAsRootScript will be executed in a nearly
        # completely isolated environment.
        unshare -imnpuf --mount-proc chroot mnt ${runAsRootScript}

        # Unmount directories and remove them.
        umount -R mnt/dev mnt/sys mnt${storeDir}
        rmdir --ignore-fail-on-non-empty \
          mnt/dev mnt/proc mnt/sys mnt${storeDir} \
          mnt$(dirname ${storeDir})
      '';

      postUmount = ''
        (cd layer; eval "${extraCommands}")

        echo "Packing layer..."
        mkdir $out
        tar -C layer --mtime=0 -cf $out/layer.tar .

        # Compute the tar checksum and add it to the output json.
        echo "Computing checksum..."
        ts=$(${tarsum} < $out/layer.tar)
        cat ${baseJson} | jshon -s "$ts" -i checksum > $out/json
        # Indicate to docker that we're using schema version 1.0.
        echo -n "1.0" > $out/VERSION

        echo "Finished building layer '${name}'"
      '';
    };

  # 1. extract the base image
  # 2. create the layer
  # 3. add layer deps to the layer itself, diffing with the base image
  # 4. compute the layer id
  # 5. put the layer in the image
  # 6. repack the image
  buildImage = args@{
    # Image name.
    name,
    # Image tag.
    tag ? "latest",
    # Parent image, to append to.
    fromImage ? null,
    # Name of the parent image; will be read from the image otherwise.
    fromImageName ? null,
    # Tag of the parent image; will be read from the image otherwise.
    fromImageTag ? null,
    # Files to put on the image (a nix store path or list of paths).
    contents ? null,
    # Docker config; e.g. what command to run on the container.
    config ? null,
    # Optional bash script to run on the files prior to fixturizing the layer.
    extraCommands ? "",
    # Optional bash script to run as root on the image when provisioning.
    runAsRoot ? null,
    # Size of the virtual machine disk to provision when building the image.
    diskSize ? 1024,
  }:

    let
      baseName = baseNameOf name;

      # Create a JSON blob of the configuration. Set the date to unix zero.
      baseJson = writeText "${baseName}-config.json" (builtins.toJSON {
        created = "1970-01-01T00:00:01Z";
        architecture = "amd64";
        os = "linux";
        config = config;
      });

      layer =
        if runAsRoot == null
        then mkPureLayer {
          name = baseName;
          inherit baseJson contents extraCommands;
        } else mkRootLayer {
          name = baseName;
          inherit baseJson fromImage fromImageName fromImageTag
                  contents runAsRoot diskSize extraCommands;
        };
      result = runCommand "docker-image-${baseName}.tar.gz" {
        buildInputs = [ jshon pigz coreutils findutils ];
        imageName = name;
        imageTag = tag;
        inherit fromImage baseJson;
        layerClosure = writeReferencesToFile layer;
        passthru.buildArgs = args;
        passthru.layer = layer;
      } ''
        # Print tar contents:
        # 1: Interpreted as relative to the root directory
        # 2: With no trailing slashes on directories
        # This is useful for ensuring that the output matches the
        # values generated by the "find" command
        ls_tar() {
          for f in $(tar -tf $1 | xargs realpath -ms --relative-to=.); do
            if [[ "$f" != "." ]]; then
              echo "/$f"
            fi
          done
        }

        mkdir image
        touch baseFiles
        if [[ -n "$fromImage" ]]; then
          echo "Unpacking base image..."
          tar -C image -xpf "$fromImage"

          if [[ -z "$fromImageName" ]]; then
            fromImageName=$(jshon -k < image/repositories|head -n1)
          fi
          if [[ -z "$fromImageTag" ]]; then
            fromImageTag=$(jshon -e $fromImageName -k \
                           < image/repositories|head -n1)
          fi
          parentID=$(jshon -e $fromImageName -e $fromImageTag -u \
                     < image/repositories)

          for l in image/*/layer.tar; do
            ls_tar $l >> baseFiles
          done
        fi

        chmod -R ug+rw image

        mkdir temp
        cp ${layer}/* temp/
        chmod ug+w temp/*

        echo "$(dirname ${storeDir})" >> layerFiles
        echo '${storeDir}' >> layerFiles
        for dep in $(cat $layerClosure); do
          find $dep >> layerFiles
        done

        echo "Adding layer..."
        # Record the contents of the tarball with ls_tar.
        ls_tar temp/layer.tar >> baseFiles

        # Get the files in the new layer which were *not* present in
        # the old layer, and record them as newFiles.
        comm <(sort -n baseFiles|uniq) \
             <(sort -n layerFiles|uniq|grep -v ${layer}) -1 -3 > newFiles
        # Append the new files to the layer.
        tar -rpf temp/layer.tar --mtime=0 --no-recursion --files-from newFiles

        echo "Adding meta..."

        # If we have a parentID, add it to the json metadata.
        if [[ -n "$parentID" ]]; then
          cat temp/json | jshon -s "$parentID" -i parent > tmpjson
          mv tmpjson temp/json
        fi

        # Take the sha256 sum of the generated json and use it as the layer ID.
        # Compute the size and add it to the json under the 'Size' field.
        layerID=$(sha256sum temp/json|cut -d ' ' -f 1)
        size=$(stat --printf="%s" temp/layer.tar)
        cat temp/json | jshon -s "$layerID" -i id -n $size -i Size > tmpjson
        mv tmpjson temp/json

        # Use the temp folder we've been working on to create a new image.
        mv temp image/$layerID

        # Store the json under the name image/repositories.
        jshon -n object \
          -n object -s "$layerID" -i "$imageTag" \
          -i "$imageName" > image/repositories

        # Make the image read-only.
        chmod -R a-w image

        echo "Cooking the image..."
        tar -C image --mtime=0 -c . | pigz -nT > $out

        echo "Finished."
      '';

    in
    result;
}

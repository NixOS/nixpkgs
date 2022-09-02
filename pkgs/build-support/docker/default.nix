{ bashInteractive
, buildPackages
, cacert
, callPackage
, closureInfo
, coreutils
, e2fsprogs
, fakechroot
, fakeNss
, fakeroot
, go
, jq
, jshon
, lib
, makeWrapper
, moreutils
, nix
, nixosTests
, pigz
, rsync
, runCommand
, runtimeShell
, shadow
, skopeo
, storeDir ? builtins.storeDir
, substituteAll
, symlinkJoin
, tarsum
, util-linux
, vmTools
, writeReferencesToFile
, writeScript
, writeText
, writeTextDir
, writePython3
}:

let
  inherit (lib)
    optionals
    optionalString
    ;

  inherit (lib)
    escapeShellArgs
    toList
    ;

  mkDbExtraCommand = contents:
    let
      contentsList = if builtins.isList contents then contents else [ contents ];
    in
    ''
      echo "Generating the nix database..."
      echo "Warning: only the database of the deepest Nix layer is loaded."
      echo "         If you want to use nix commands in the container, it would"
      echo "         be better to only have one layer that contains a nix store."

      export NIX_REMOTE=local?root=$PWD
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      export USER=nobody
      ${buildPackages.nix}/bin/nix-store --load-db < ${closureInfo {rootPaths = contentsList;}}/registration

      mkdir -p nix/var/nix/gcroots/docker/
      for i in ${lib.concatStringsSep " " contentsList}; do
      ln -s $i nix/var/nix/gcroots/docker/$(basename $i)
      done;
    '';

  # The OCI Image specification recommends that configurations use values listed
  # in the Go Language document for GOARCH.
  # Reference: https://github.com/opencontainers/image-spec/blob/master/config.md#properties
  # For the mapping from Nixpkgs system parameters to GOARCH, we can reuse the
  # mapping from the go package.
  defaultArch = go.GOARCH;

in
rec {
  examples = callPackage ./examples.nix {
    inherit buildImage buildLayeredImage fakeNss pullImage shadowSetup buildImageWithNixDb;
  };

  tests = {
    inherit (nixosTests)
      docker-tools
      docker-tools-overlay
      # requires remote builder
      # docker-tools-cross
      ;
  };

  pullImage =
    let
      fixName = name: builtins.replaceStrings [ "/" ":" ] [ "-" "-" ] name;
    in
    { imageName
      # To find the digest of an image, you can use skopeo:
      # see doc/functions.xml
    , imageDigest
    , sha256
    , os ? "linux"
    , arch ? defaultArch

      # This is used to set name to the pulled image
    , finalImageName ? imageName
      # This used to set a tag to the pulled image
    , finalImageTag ? "latest"
      # This is used to disable TLS certificate verification, allowing access to http registries on (hopefully) trusted networks
    , tlsVerify ? true

    , name ? fixName "docker-image-${finalImageName}-${finalImageTag}.tar"
    }:

    runCommand name
      {
        inherit imageDigest;
        imageName = finalImageName;
        imageTag = finalImageTag;
        impureEnvVars = lib.fetchers.proxyImpureEnvVars;
        outputHashMode = "flat";
        outputHashAlgo = "sha256";
        outputHash = sha256;

        nativeBuildInputs = [ skopeo ];
        SSL_CERT_FILE = "${cacert.out}/etc/ssl/certs/ca-bundle.crt";

        sourceURL = "docker://${imageName}@${imageDigest}";
        destNameTag = "${finalImageName}:${finalImageTag}";
      } ''
      skopeo \
        --insecure-policy \
        --tmpdir=$TMPDIR \
        --override-os ${os} \
        --override-arch ${arch} \
        copy \
        --src-tls-verify=${lib.boolToString tlsVerify} \
        "$sourceURL" "docker-archive://$out:$destNameTag" \
        | cat  # pipe through cat to force-disable progress bar
    '';

  # We need to sum layer.tar, not a directory, hence tarsum instead of nix-hash.
  # And we cannot untar it, because then we cannot preserve permissions etc.
  inherit tarsum; # pkgs.dockerTools.tarsum

  # buildEnv creates symlinks to dirs, which is hard to edit inside the overlay VM
  mergeDrvs =
    { derivations
    , onlyDeps ? false
    }:
    runCommand "merge-drvs"
      {
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
      echo "root:x:0:0::/root:${runtimeShell}" > /etc/passwd
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
  runWithOverlay =
    { name
    , fromImage ? null
    , fromImageName ? null
    , fromImageTag ? null
    , diskSize ? 1024
    , buildVMMemorySize ? 512
    , preMount ? ""
    , postMount ? ""
    , postUmount ? ""
    }:
      vmTools.runInLinuxVM (
        runCommand name
          {
            preVM = vmTools.createEmptyImage {
              size = diskSize;
              fullName = "docker-run-disk";
              destination = "./image";
            };
            inherit fromImage fromImageName fromImageTag;
            memSize = buildVMMemorySize;

            nativeBuildInputs = [ util-linux e2fsprogs jshon rsync jq ];
          } ''
          mkdir disk
          mkfs /dev/${vmTools.hd}
          mount /dev/${vmTools.hd} disk
          cd disk

          if [[ -n "$fromImage" ]]; then
            echo "Unpacking base image..."
            mkdir image
            tar -C image -xpf "$fromImage"

            if [[ -n "$fromImageName" ]] && [[ -n "$fromImageTag" ]]; then
              parentID="$(
                cat "image/manifest.json" |
                  jq -r '.[] | select(.RepoTags | contains([$desiredTag])) | rtrimstr(".json")' \
                    --arg desiredTag "$fromImageName:$fromImageTag"
              )"
            else
              echo "From-image name or tag wasn't set. Reading the first ID."
              parentID="$(cat "image/manifest.json" | jq -r '.[0].Config | rtrimstr(".json")')"
            fi

            cat ./image/manifest.json  | jq -r '.[0].Layers | .[]' > layer-list
          else
            touch layer-list
          fi

          # Unpack all of the parent layers into the image.
          lowerdir=""
          extractionID=0
          for layerTar in $(cat layer-list); do
            echo "Unpacking layer $layerTar"
            extractionID=$((extractionID + 1))

            mkdir -p image/$extractionID/layer
            tar -C image/$extractionID/layer -xpf image/$layerTar
            rm image/$layerTar

            find image/$extractionID/layer -name ".wh.*" -exec bash -c 'name="$(basename {}|sed "s/^.wh.//")"; mknod "$(dirname {})/$name" c 0 0; rm {}' \;

            # Get the next lower directory and continue the loop.
            lowerdir=image/$extractionID/layer''${lowerdir:+:}$lowerdir
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
        tar -C mnt --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" -cf $out/layer.tar .
      '';

      postUmount = ''
        mv $out/layer.tar .
        rm -rf $out
        mv layer.tar $out
      '';
    };

  # Create an executable shell script which has the coreutils in its
  # PATH. Since root scripts are executed in a blank environment, even
  # things like `ls` or `echo` will be missing.
  shellScript = name: text:
    writeScript name ''
      #!${runtimeShell}
      set -e
      export PATH=${coreutils}/bin:/bin
      ${text}
    '';

  # Create a "layer" (set of files).
  mkPureLayer =
    {
      # Name of the layer
      name
    , # JSON containing configuration and metadata for this layer.
      baseJson
    , # Files to add to the layer.
      copyToRoot ? null
    , # When copying the contents into the image, preserve symlinks to
      # directories (see `rsync -K`).  Otherwise, transform those symlinks
      # into directories.
      keepContentsDirlinks ? false
    , # Additional commands to run on the layer before it is tar'd up.
      extraCommands ? ""
    , uid ? 0
    , gid ? 0
    }:
    runCommand "docker-layer-${name}"
      {
        inherit baseJson extraCommands;
        contents = copyToRoot;
        nativeBuildInputs = [ jshon rsync tarsum ];
      }
      ''
        mkdir layer
        if [[ -n "$contents" ]]; then
          echo "Adding contents..."
          for item in $contents; do
            echo "Adding $item"
            rsync -a${if keepContentsDirlinks then "K" else "k"} --chown=0:0 $item/ layer/
          done
        else
          echo "No contents to add to layer."
        fi

        chmod ug+w layer

        if [[ -n "$extraCommands" ]]; then
          (cd layer; eval "$extraCommands")
        fi

        # Tar up the layer and throw it into 'layer.tar'.
        echo "Packing layer..."
        mkdir $out
        tarhash=$(tar -C layer --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" --owner=${toString uid} --group=${toString gid} -cf - . | tee -p $out/layer.tar | tarsum)

        # Add a 'checksum' field to the JSON, with the value set to the
        # checksum of the tarball.
        cat ${baseJson} | jshon -s "$tarhash" -i checksum > $out/json

        # Indicate to docker that we're using schema version 1.0.
        echo -n "1.0" > $out/VERSION

        echo "Finished building layer '${name}'"
      '';

  # Make a "root" layer; required if we need to execute commands as a
  # privileged user on the image. The commands themselves will be
  # performed in a virtual machine sandbox.
  mkRootLayer =
    {
      # Name of the image.
      name
    , # Script to run as root. Bash.
      runAsRoot
    , # Files to add to the layer. If null, an empty layer will be created.
      # To add packages to /bin, use `buildEnv` or similar.
      copyToRoot ? null
    , # When copying the contents into the image, preserve symlinks to
      # directories (see `rsync -K`).  Otherwise, transform those symlinks
      # into directories.
      keepContentsDirlinks ? false
    , # JSON containing configuration and metadata for this layer.
      baseJson
    , # Existing image onto which to append the new layer.
      fromImage ? null
    , # Name of the image we're appending onto.
      fromImageName ? null
    , # Tag of the image we're appending onto.
      fromImageTag ? null
    , # How much disk to allocate for the temporary virtual machine.
      diskSize ? 1024
    , # How much memory to allocate for the temporary virtual machine.
      buildVMMemorySize ? 512
    , # Commands (bash) to run on the layer; these do not require sudo.
      extraCommands ? ""
    }:
    # Generate an executable script from the `runAsRoot` text.
    let
      runAsRootScript = shellScript "run-as-root.sh" runAsRoot;
      extraCommandsScript = shellScript "extra-commands.sh" extraCommands;
    in
    runWithOverlay {
      name = "docker-layer-${name}";

      inherit fromImage fromImageName fromImageTag diskSize buildVMMemorySize;

      preMount = lib.optionalString (copyToRoot != null && copyToRoot != [ ]) ''
        echo "Adding contents..."
        for item in ${escapeShellArgs (map (c: "${c}") (toList copyToRoot))}; do
          echo "Adding $item..."
          rsync -a${if keepContentsDirlinks then "K" else "k"} --chown=0:0 $item/ layer/
        done

        chmod ug+w layer
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
        #
        # Ideally we would use --mount-proc=mnt/proc or similar, but this
        # doesn't work. The workaround is to setup proc after unshare.
        # See: https://github.com/karelzak/util-linux/issues/648
        unshare -imnpuf --mount-proc sh -c 'mount --rbind /proc mnt/proc && chroot mnt ${runAsRootScript}'

        # Unmount directories and remove them.
        umount -R mnt/dev mnt/sys mnt${storeDir}
        rmdir --ignore-fail-on-non-empty \
          mnt/dev mnt/proc mnt/sys mnt${storeDir} \
          mnt$(dirname ${storeDir})
      '';

      postUmount = ''
        (cd layer; ${extraCommandsScript})

        echo "Packing layer..."
        mkdir -p $out
        tarhash=$(tar -C layer --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" -cf - . |
                    tee -p $out/layer.tar |
                    ${tarsum}/bin/tarsum)

        cat ${baseJson} | jshon -s "$tarhash" -i checksum > $out/json
        # Indicate to docker that we're using schema version 1.0.
        echo -n "1.0" > $out/VERSION

        echo "Finished building layer '${name}'"
      '';
    };

  buildLayeredImage = { name, ... }@args:
    let
      stream = streamLayeredImage args;
    in
    runCommand "${baseNameOf name}.tar.gz"
      {
        inherit (stream) imageName;
        passthru = { inherit (stream) imageTag; };
        nativeBuildInputs = [ pigz ];
      } "${stream} | pigz -nT > $out";

  # 1. extract the base image
  # 2. create the layer
  # 3. add layer deps to the layer itself, diffing with the base image
  # 4. compute the layer id
  # 5. put the layer in the image
  # 6. repack the image
  buildImage =
    args@{
      # Image name.
      name
    , # Image tag, when null then the nix output hash will be used.
      tag ? null
    , # Parent image, to append to.
      fromImage ? null
    , # Name of the parent image; will be read from the image otherwise.
      fromImageName ? null
    , # Tag of the parent image; will be read from the image otherwise.
      fromImageTag ? null
    , # Files to put on the image (a nix store path or list of paths).
      copyToRoot ? null
    , # When copying the contents into the image, preserve symlinks to
      # directories (see `rsync -K`).  Otherwise, transform those symlinks
      # into directories.
      keepContentsDirlinks ? false
    , # Docker config; e.g. what command to run on the container.
      config ? null
    , # Optional bash script to run on the files prior to fixturizing the layer.
      extraCommands ? ""
    , uid ? 0
    , gid ? 0
    , # Optional bash script to run as root on the image when provisioning.
      runAsRoot ? null
    , # Size of the virtual machine disk to provision when building the image.
      diskSize ? 1024
    , # Size of the virtual machine memory to provision when building the image.
      buildVMMemorySize ? 512
    , # Time of creation of the image.
      created ? "1970-01-01T00:00:01Z"
    , # Deprecated.
      contents ? null
    ,
    }:

    let
      checked =
        lib.warnIf (contents != null)
          "in docker image ${name}: The contents parameter is deprecated. Change to copyToRoot if the contents are designed to be copied to the root filesystem, such as when you use `buildEnv` or similar between contents and your packages. Use copyToRoot = buildEnv { ... }; or similar if you intend to add packages to /bin."
        lib.throwIf (contents != null && copyToRoot != null) "in docker image ${name}: You can not specify both contents and copyToRoot."
        ;

      rootContents = if copyToRoot == null then contents else copyToRoot;

      baseName = baseNameOf name;

      # Create a JSON blob of the configuration. Set the date to unix zero.
      baseJson =
        let
          pure = writeText "${baseName}-config.json" (builtins.toJSON {
            inherit created config;
            architecture = defaultArch;
            os = "linux";
          });
          impure = runCommand "${baseName}-config.json"
            { nativeBuildInputs = [ jq ]; }
            ''
              jq ".created = \"$(TZ=utc date --iso-8601="seconds")\"" ${pure} > $out
            '';
        in
        if created == "now" then impure else pure;

      layer =
        if runAsRoot == null
        then
          mkPureLayer
            {
              name = baseName;
              inherit baseJson keepContentsDirlinks extraCommands uid gid;
              copyToRoot = rootContents;
            } else
          mkRootLayer {
            name = baseName;
            inherit baseJson fromImage fromImageName fromImageTag
              keepContentsDirlinks runAsRoot diskSize buildVMMemorySize
              extraCommands;
            copyToRoot = rootContents;
          };
      result = runCommand "docker-image-${baseName}.tar.gz"
        {
          nativeBuildInputs = [ jshon pigz jq moreutils ];
          # Image name must be lowercase
          imageName = lib.toLower name;
          imageTag = if tag == null then "" else tag;
          inherit fromImage baseJson;
          layerClosure = writeReferencesToFile layer;
          passthru.buildArgs = args;
          passthru.layer = layer;
          passthru.imageTag =
            if tag != null
            then tag
            else
              lib.head (lib.strings.splitString "-" (baseNameOf result.outPath));
        } ''
        ${lib.optionalString (tag == null) ''
          outName="$(basename "$out")"
          outHash=$(echo "$outName" | cut -d - -f 1)

          imageTag=$outHash
        ''}

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
        baseEnvs='[]'
        if [[ -n "$fromImage" ]]; then
          echo "Unpacking base image..."
          tar -C image -xpf "$fromImage"

          # Store the layers and the environment variables from the base image
          cat ./image/manifest.json  | jq -r '.[0].Layers | .[]' > layer-list
          configName="$(cat ./image/manifest.json | jq -r '.[0].Config')"
          baseEnvs="$(cat "./image/$configName" | jq '.config.Env // []')"

          # Extract the parentID from the manifest
          if [[ -n "$fromImageName" ]] && [[ -n "$fromImageTag" ]]; then
            parentID="$(
              cat "image/manifest.json" |
                jq -r '.[] | select(.RepoTags | contains([$desiredTag])) | rtrimstr(".json")' \
                  --arg desiredTag "$fromImageName:$fromImageTag"
            )"
          else
            echo "From-image name or tag wasn't set. Reading the first ID."
            parentID="$(cat "image/manifest.json" | jq -r '.[0].Config | rtrimstr(".json")')"
          fi

          # Otherwise do not import the base image configuration and manifest
          chmod a+w image image/*.json
          rm -f image/*.json

          for l in image/*/layer.tar; do
            ls_tar $l >> baseFiles
          done
        else
          touch layer-list
        fi

        chmod -R ug+rw image

        mkdir temp
        cp ${layer}/* temp/
        chmod ug+w temp/*

        for dep in $(cat $layerClosure); do
          find $dep >> layerFiles
        done

        echo "Adding layer..."
        # Record the contents of the tarball with ls_tar.
        ls_tar temp/layer.tar >> baseFiles

        # Append nix/store directory to the layer so that when the layer is loaded in the
        # image /nix/store has read permissions for non-root users.
        # nix/store is added only if the layer has /nix/store paths in it.
        if [ $(wc -l < $layerClosure) -gt 1 ] && [ $(grep -c -e "^/nix/store$" baseFiles) -eq 0 ]; then
          mkdir -p nix/store
          chmod -R 555 nix
          echo "./nix" >> layerFiles
          echo "./nix/store" >> layerFiles
        fi

        # Get the files in the new layer which were *not* present in
        # the old layer, and record them as newFiles.
        comm <(sort -n baseFiles|uniq) \
             <(sort -n layerFiles|uniq|grep -v ${layer}) -1 -3 > newFiles
        # Append the new files to the layer.
        tar -rpf temp/layer.tar --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
          --owner=0 --group=0 --no-recursion --verbatim-files-from --files-from newFiles

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

        # Add the new layer ID to the end of the layer list
        (
          cat layer-list
          # originally this used `sed -i "1i$layerID" layer-list`, but
          # would fail if layer-list was completely empty.
          echo "$layerID/layer.tar"
        ) | sponge layer-list

        # Create image json and image manifest
        imageJson=$(cat ${baseJson} | jq '.config.Env = $baseenv + .config.Env' --argjson baseenv "$baseEnvs")
        imageJson=$(echo "$imageJson" | jq ". + {\"rootfs\": {\"diff_ids\": [], \"type\": \"layers\"}}")
        manifestJson=$(jq -n "[{\"RepoTags\":[\"$imageName:$imageTag\"]}]")

        for layerTar in $(cat ./layer-list); do
          layerChecksum=$(sha256sum image/$layerTar | cut -d ' ' -f1)
          imageJson=$(echo "$imageJson" | jq ".history |= . + [{\"created\": \"$(jq -r .created ${baseJson})\"}]")
          # diff_ids order is from the bottom-most to top-most layer
          imageJson=$(echo "$imageJson" | jq ".rootfs.diff_ids |= . + [\"sha256:$layerChecksum\"]")
          manifestJson=$(echo "$manifestJson" | jq ".[0].Layers |= . + [\"$layerTar\"]")
        done

        imageJsonChecksum=$(echo "$imageJson" | sha256sum | cut -d ' ' -f1)
        echo "$imageJson" > "image/$imageJsonChecksum.json"
        manifestJson=$(echo "$manifestJson" | jq ".[0].Config = \"$imageJsonChecksum.json\"")
        echo "$manifestJson" > image/manifest.json

        # Store the json under the name image/repositories.
        jshon -n object \
          -n object -s "$layerID" -i "$imageTag" \
          -i "$imageName" > image/repositories

        # Make the image read-only.
        chmod -R a-w image

        echo "Cooking the image..."
        tar -C image --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" --owner=0 --group=0 --xform s:'^./':: -c . | pigz -nT > $out

        echo "Finished."
      '';

    in
    checked result;

  # Merge the tarballs of images built with buildImage into a single
  # tarball that contains all images. Running `docker load` on the resulting
  # tarball will load the images into the docker daemon.
  mergeImages = images: runCommand "merge-docker-images"
    {
      inherit images;
      nativeBuildInputs = [ pigz jq ];
    } ''
    mkdir image inputs
    # Extract images
    repos=()
    manifests=()
    for item in $images; do
      name=$(basename $item)
      mkdir inputs/$name
      tar -I pigz -xf $item -C inputs/$name
      if [ -f inputs/$name/repositories ]; then
        repos+=(inputs/$name/repositories)
      fi
      if [ -f inputs/$name/manifest.json ]; then
        manifests+=(inputs/$name/manifest.json)
      fi
    done
    # Copy all layers from input images to output image directory
    cp -R --no-clobber inputs/*/* image/
    # Merge repositories objects and manifests
    jq -s add "''${repos[@]}" > repositories
    jq -s add "''${manifests[@]}" > manifest.json
    # Replace output image repositories and manifest with merged versions
    mv repositories image/repositories
    mv manifest.json image/manifest.json
    # Create tarball and gzip
    tar -C image --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" --owner=0 --group=0 --xform s:'^./':: -c . | pigz -nT > $out
  '';


  # Provide a /etc/passwd and /etc/group that contain root and nobody.
  # Useful when packaging binaries that insist on using nss to look up
  # username/groups (like nginx).
  # /bin/sh is fine to not exist, and provided by another shim.
  inherit fakeNss; # alias

  # This provides a /usr/bin/env, for shell scripts using the
  # "#!/usr/bin/env executable" shebang.
  usrBinEnv = runCommand "usr-bin-env" { } ''
    mkdir -p $out/usr/bin
    ln -s ${coreutils}/bin/env $out/usr/bin
  '';

  # This provides /bin/sh, pointing to bashInteractive.
  binSh = runCommand "bin-sh" { } ''
    mkdir -p $out/bin
    ln -s ${bashInteractive}/bin/bash $out/bin/sh
  '';

  # This provides the ca bundle in common locations
  caCertificates = runCommand "ca-certificates" { } ''
    # Old NixOS compatibility.
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-bundle.crt
    # NixOS canonical location + Debian/Ubuntu/Arch/Gentoo compatibility.
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-certificates.crt
    # CentOS/Fedora compatibility.
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/pki/tls/certs/ca-bundle.crt
  '';

  # Build an image and populate its nix database with the provided
  # contents. The main purpose is to be able to use nix commands in
  # the container.
  # Be careful since this doesn't work well with multilayer.
  # TODO: add the dependencies of the config json.
  buildImageWithNixDb = args@{ copyToRoot ? contents, contents ? null, extraCommands ? "", ... }: (
    buildImage (args // {
      extraCommands = (mkDbExtraCommand copyToRoot) + extraCommands;
    })
  );

  # TODO: add the dependencies of the config json.
  buildLayeredImageWithNixDb = args@{ contents ? null, extraCommands ? "", ... }: (
    buildLayeredImage (args // {
      extraCommands = (mkDbExtraCommand contents) + extraCommands;
    })
  );

  streamLayeredImage =
    {
      # Image Name
      name
    , # Image tag, the Nix's output hash will be used if null
      tag ? null
    , # Parent image, to append to.
      fromImage ? null
    , # Files to put on the image (a nix store path or list of paths).
      contents ? [ ]
    , # Docker config; e.g. what command to run on the container.
      config ? { }
    , # Time of creation of the image. Passing "now" will make the
      # created date be the time of building.
      created ? "1970-01-01T00:00:01Z"
    , # Optional bash script to run on the files prior to fixturizing the layer.
      extraCommands ? ""
    , # Optional bash script to run inside fakeroot environment.
      # Could be used for changing ownership of files in customisation layer.
      fakeRootCommands ? ""
    , # Whether to run fakeRootCommands in fakechroot as well, so that they
      # appear to run inside the image, but have access to the normal Nix store.
      # Perhaps this could be enabled on by default on pkgs.stdenv.buildPlatform.isLinux
      enableFakechroot ? false
    , # We pick 100 to ensure there is plenty of room for extension. I
      # believe the actual maximum is 128.
      maxLayers ? 100
    , # Whether to include store paths in the image. You generally want to leave
      # this on, but tooling may disable this to insert the store paths more
      # efficiently via other means, such as bind mounting the host store.
      includeStorePaths ? true
    , # Passthru arguments for the underlying derivation.
      passthru ? {}
    ,
    }:
      assert
      (lib.assertMsg (maxLayers > 1)
        "the maxLayers argument of dockerTools.buildLayeredImage function must be greather than 1 (current value: ${toString maxLayers})");
      let
        baseName = baseNameOf name;

        streamScript = writePython3 "stream" { } ./stream_layered_image.py;
        baseJson = writeText "${baseName}-base.json" (builtins.toJSON {
          inherit config;
          architecture = defaultArch;
          os = "linux";
        });

        contentsList = if builtins.isList contents then contents else [ contents ];

        # We store the customisation layer as a tarball, to make sure that
        # things like permissions set on 'extraCommands' are not overriden
        # by Nix. Then we precompute the sha256 for performance.
        customisationLayer = symlinkJoin {
          name = "${baseName}-customisation-layer";
          paths = contentsList;
          inherit extraCommands fakeRootCommands;
          nativeBuildInputs = [
            fakeroot
          ] ++ optionals enableFakechroot [
            fakechroot
            # for chroot
            coreutils
            # fakechroot needs getopt, which is provided by util-linux
            util-linux
          ];
          postBuild = ''
            mv $out old_out
            (cd old_out; eval "$extraCommands" )

            mkdir $out
            ${optionalString enableFakechroot ''
              export FAKECHROOT_EXCLUDE_PATH=/dev:/proc:/sys:${builtins.storeDir}:$out/layer.tar
            ''}
            ${optionalString enableFakechroot ''fakechroot chroot $PWD/old_out ''}fakeroot bash -c '
              source $stdenv/setup
              ${optionalString (!enableFakechroot) ''cd old_out''}
              eval "$fakeRootCommands"
              tar \
                --sort name \
                --numeric-owner --mtime "@$SOURCE_DATE_EPOCH" \
                --hard-dereference \
                -cf $out/layer.tar .
            '

            sha256sum $out/layer.tar \
              | cut -f 1 -d ' ' \
              > $out/checksum
          '';
        };

        closureRoots = lib.optionals includeStorePaths /* normally true */ (
          [ baseJson customisationLayer ]
        );
        overallClosure = writeText "closure" (lib.concatStringsSep " " closureRoots);

        # These derivations are only created as implementation details of docker-tools,
        # so they'll be excluded from the created images.
        unnecessaryDrvs = [ baseJson overallClosure customisationLayer ];

        conf = runCommand "${baseName}-conf.json"
          {
            inherit fromImage maxLayers created;
            imageName = lib.toLower name;
            passthru.imageTag =
              if tag != null
              then tag
              else
                lib.head (lib.strings.splitString "-" (baseNameOf conf.outPath));
            paths = buildPackages.referencesByPopularity overallClosure;
            nativeBuildInputs = [ jq ];
          } ''
          ${if (tag == null) then ''
            outName="$(basename "$out")"
            outHash=$(echo "$outName" | cut -d - -f 1)

            imageTag=$outHash
          '' else ''
            imageTag="${tag}"
          ''}

          # convert "created" to iso format
          if [[ "$created" != "now" ]]; then
              created="$(date -Iseconds -d "$created")"
          fi

          paths() {
            cat $paths ${lib.concatMapStringsSep " "
                           (path: "| (grep -v ${path} || true)")
                           unnecessaryDrvs}
          }

          # Compute the number of layers that are already used by a potential
          # 'fromImage' as well as the customization layer. Ensure that there is
          # still at least one layer available to store the image contents.
          usedLayers=0

          # subtract number of base image layers
          if [[ -n "$fromImage" ]]; then
            (( usedLayers += $(tar -xOf "$fromImage" manifest.json | jq '.[0].Layers | length') ))
          fi

          # one layer will be taken up by the customisation layer
          (( usedLayers += 1 ))

          if ! (( $usedLayers < $maxLayers )); then
            echo >&2 "Error: usedLayers $usedLayers layers to store 'fromImage' and" \
                      "'extraCommands', but only maxLayers=$maxLayers were" \
                      "allowed. At least 1 layer is required to store contents."
            exit 1
          fi
          availableLayers=$(( maxLayers - usedLayers ))

          # Create $maxLayers worth of Docker Layers, one layer per store path
          # unless there are more paths than $maxLayers. In that case, create
          # $maxLayers-1 for the most popular layers, and smush the remainaing
          # store paths in to one final layer.
          #
          # The following code is fiddly w.r.t. ensuring every layer is
          # created, and that no paths are missed. If you change the
          # following lines, double-check that your code behaves properly
          # when the number of layers equals:
          #      maxLayers-1, maxLayers, and maxLayers+1, 0
          store_layers="$(
            paths |
              jq -sR '
                rtrimstr("\n") | split("\n")
                  | (.[:$maxLayers-1] | map([.])) + [ .[$maxLayers-1:] ]
                  | map(select(length > 0))
              ' \
                --argjson maxLayers "$availableLayers"
          )"

          cat ${baseJson} | jq '
            . + {
              "store_dir": $store_dir,
              "from_image": $from_image,
              "store_layers": $store_layers,
              "customisation_layer", $customisation_layer,
              "repo_tag": $repo_tag,
              "created": $created
            }
            ' --arg store_dir "${storeDir}" \
              --argjson from_image ${if fromImage == null then "null" else "'\"${fromImage}\"'"} \
              --argjson store_layers "$store_layers" \
              --arg customisation_layer ${customisationLayer} \
              --arg repo_tag "$imageName:$imageTag" \
              --arg created "$created" |
            tee $out
        '';
        result = runCommand "stream-${baseName}"
          {
            inherit (conf) imageName;
            passthru = passthru // {
              inherit (conf) imageTag;

              # Distinguish tarballs and exes at the Nix level so functions that
              # take images can know in advance how the image is supposed to be used.
              isExe = true;
            };
            nativeBuildInputs = [ makeWrapper ];
          } ''
          makeWrapper ${streamScript} $out --add-flags ${conf}
        '';
      in
      result;
}

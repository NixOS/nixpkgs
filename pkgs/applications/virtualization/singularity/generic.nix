# Configurations that should only be overrided by
# overrideAttrs
{ pname
, version
, src
, projectName # "apptainer" or "singularity"
, vendorHash ? null
, deleteVendor ? false
, proxyVendor ? false
, extraConfigureFlags ? [ ]
, extraDescription ? ""
, extraMeta ? { }
}:

let
  # Workaround for vendor-related attributes not overridable (#86349)
  # should be removed when the issue is resolved
  _defaultGoVendorArgs = {
    inherit
      vendorHash
      deleteVendor
      proxyVendor
      ;
  };
in
{ lib
, buildGoModule
, runCommandLocal
  # Native build inputs
, makeWrapper
, pkg-config
, util-linux
, which
  # Build inputs
, bash
, conmon
, coreutils
, cryptsetup
, e2fsprogs
, fakeroot
, fuse2fs ? e2fsprogs.fuse2fs
, go
, gpgme
, libseccomp
, libuuid
  # This is for nvidia-container-cli
, nvidia-docker
, openssl
, squashfsTools
, squashfuse
  # Test dependencies
, singularity-tools
, cowsay
, hello
  # Overridable configurations
, enableNvidiaContainerCli ? true
  # Compile with seccomp support
  # SingularityCE 3.10.0 and above requires explicit --without-seccomp when libseccomp is not available.
, enableSeccomp ? true
  # Whether the configure script treat SUID support as default
  # When equal to enableSuid, it supress the --with-suid / --without-suid build flag
  # It can be set to `null` to always pass either --with-suid or --without-suided
  # Type: null or boolean
, defaultToSuid ? true
  # Whether to compile with SUID support
, enableSuid ? false
, starterSuidPath ? null
  # newuidmapPath and newgidmapPath are to support --fakeroot
  # where those SUID-ed executables are unavailable from the FHS system PATH.
  # Path to SUID-ed newuidmap executable
, newuidmapPath ? null
  # Path to SUID-ed newgidmap executable
, newgidmapPath ? null
  # External LOCALSTATEDIR
, externalLocalStateDir ? null
  # Remove the symlinks to `singularity*` when projectName != "singularity"
, removeCompat ? false
  # Workaround #86349
  # should be removed when the issue is resolved
, vendorHash ? _defaultGoVendorArgs.vendorHash
, deleteVendor ? _defaultGoVendorArgs.deleteVendor
, proxyVendor ? _defaultGoVendorArgs.proxyVendor
}:

let
  defaultPathOriginal = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin";
  privileged-un-utils = if ((newuidmapPath == null) && (newgidmapPath == null)) then null else
  (runCommandLocal "privileged-un-utils" { } ''
    mkdir -p "$out/bin"
    ln -s ${lib.escapeShellArg newuidmapPath} "$out/bin/newuidmap"
    ln -s ${lib.escapeShellArg newgidmapPath} "$out/bin/newgidmap"
  '');
in
(buildGoModule {
  inherit pname version src;

  # Override vendorHash with the output got from
  # nix-prefetch -E "{ sha256 }: ((import ./. { }).apptainer.override { vendorHash = sha256; }).goModules"
  # or with `null` when using vendored source tarball.
  inherit vendorHash deleteVendor proxyVendor;

  # go is used to compile extensions when building container images
  allowGoReference = true;

  strictDeps = true;

  passthru = {
    inherit
      enableSeccomp
      enableSuid
      externalLocalStateDir
      projectName
      removeCompat
      starterSuidPath
      ;
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    util-linux
    which
  ];

  # Search inside the project sources
  # and see the `control` file of the Debian package from upstream repos
  # for build-time dependencies and run-time utilities
  # apptainer/apptainer: https://github.com/apptainer/apptainer/blob/main/dist/debian/control
  # sylabs/singularity: https://github.com/sylabs/singularity/blob/main/debian/control

  buildInputs = [
    bash # To patch /bin/sh shebangs.
    conmon
    cryptsetup
    gpgme
    libuuid
    openssl
    squashfsTools # Required at build time by SingularityCE
  ]
  ++ lib.optional enableNvidiaContainerCli nvidia-docker
  ++ lib.optional enableSeccomp libseccomp
  ;

  configureScript = "./mconfig";

  configureFlags = [
    "--localstatedir=${if externalLocalStateDir != null then externalLocalStateDir else "${placeholder "out"}/var/lib"}"
    "--runstatedir=/var/run"
  ]
  ++ lib.optional (!enableSeccomp) "--without-seccomp"
  ++ lib.optional (enableSuid != defaultToSuid) (if enableSuid then "--with-suid" else "--without-suid")
  ++ extraConfigureFlags
  ;

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  # Packages to prefix to the Apptainer/Singularity container runtime default PATH
  # Use overrideAttrs to override
  defaultPathInputs = [
    bash
    coreutils
    cryptsetup # cryptsetup
    fakeroot
    fuse2fs # Mount ext3 filesystems
    go
    privileged-un-utils
    squashfsTools # mksquashfs unsquashfs # Make / unpack squashfs image
    squashfuse # squashfuse_ll squashfuse # Mount (without unpacking) a squashfs image without privileges
  ]
  ++ lib.optional enableNvidiaContainerCli nvidia-docker
  ;

  postPatch = ''
    if [[ ! -e .git || ! -e VERSION ]]; then
      echo "${version}" > VERSION
    fi
    # Patch shebangs for script run during build
    patchShebangs --build "$configureScript" makeit e2e scripts mlocal/scripts
    # Patching the hard-coded defaultPath by prefixing the packages in defaultPathInputs
    substituteInPlace cmd/internal/cli/actions.go \
      --replace "defaultPath = \"${defaultPathOriginal}\"" "defaultPath = \"''${defaultPathInputs// /\/bin:}''${defaultPathInputs:+/bin:}${defaultPathOriginal}\""
  '';

  postConfigure = ''
    # Code borrowed from pkgs/stdenv/generic/setup.sh configurePhase()

    # set to empty if unset
    : ''${configureFlags=}

    # shellcheck disable=SC2086
    $configureScript -V ${version} "''${prefixKey:---prefix=}$prefix" $configureFlags "''${configureFlagsArray[@]}"

    # End of the code from pkgs/stdenv/generic/setup.sh configurPhase()
  '';

  buildPhase = ''
    runHook preBuild
    make -C builddir -j"$NIX_BUILD_CORES"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C builddir install LOCALSTATEDIR="$out/var/lib"
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace "$out/bin/run-singularity" \
      --replace "/usr/bin/env ${projectName}" "$out/bin/${projectName}"
    wrapProgram "$out/bin/${projectName}" \
      --prefix PATH : "''${defaultPathInputs// /\/bin:}''${defaultPathInputs:+/bin:}"
    # Make changes in the config file
    ${lib.optionalString enableNvidiaContainerCli ''
      substituteInPlace "$out/etc/${projectName}/${projectName}.conf" \
        --replace "use nvidia-container-cli = no" "use nvidia-container-cli = yes"
    ''}
    ${lib.optionalString (enableNvidiaContainerCli && projectName == "singularity") ''
      substituteInPlace "$out/etc/${projectName}/${projectName}.conf" \
        --replace "# nvidia-container-cli path =" "nvidia-container-cli path = ${nvidia-docker}/bin/nvidia-container-cli"
    ''}
    ${lib.optionalString (removeCompat && (projectName != "singularity")) ''
      unlink "$out/bin/singularity"
      for file in "$out"/share/man/man?/singularity*.gz; do
        if [[ -L "$file" ]]; then
          unlink "$file"
        fi
      done
      for file in "$out"/share/*-completion/completions/singularity; do
        if [[ -e "$file" ]]
        rm "$file"
      done
    ''}
    ${lib.optionalString enableSuid (lib.warnIf (starterSuidPath == null) "${projectName}: Null starterSuidPath when enableSuid produces non-SUID-ed starter-suid and run-time permission denial." ''
      chmod +x $out/libexec/${projectName}/bin/starter-suid
    '')}
    ${lib.optionalString (enableSuid && (starterSuidPath != null)) ''
      mv "$out"/libexec/${projectName}/bin/starter-suid{,.orig}
      ln -s ${lib.escapeShellArg starterSuidPath} "$out/libexec/${projectName}/bin/starter-suid"
    ''}
  '';

  meta = with lib; {
    description = "Application containers for linux" + extraDescription;
    longDescription = ''
      Singularity (the upstream) renamed themselves to Apptainer
      to distinguish themselves from a fork made by Sylabs Inc.. See

      https://sylabs.io/2021/05/singularity-community-edition
      https://apptainer.org/news/community-announcement-20211130
    '';
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jbedo ShamrockLee ];
    mainProgram = projectName;
  } // extraMeta;
}).overrideAttrs (finalAttrs: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    tests = {
      image-hello-cowsay = singularity-tools.buildImage {
        name = "hello-cowsay";
        contents = [ hello cowsay ];
        singularity = finalAttrs.finalPackage;
      };
    };
  };
})

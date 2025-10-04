# Configurations that should only be overrided by
# overrideAttrs
{
  pname,
  version,
  src,
  projectName, # "apptainer" or "singularity"
  vendorHash ? null,
  deleteVendor ? false,
  proxyVendor ? false,
  extraConfigureFlags ? [ ],
  extraDescription ? "",
  extraMeta ? { },
}:
{
  lib,
  buildGoModule,
  runCommandLocal,
  replaceVars,
  # Native build inputs
  addDriverRunpath,
  makeWrapper,
  pkg-config,
  util-linux,
  which,
  # Build inputs
  bash,
  callPackage,
  conmon,
  coreutils,
  cryptsetup,
  e2fsprogs,
  fakeroot,
  fuse2fs ? e2fsprogs.fuse2fs,
  go,
  gpgme,
  libseccomp,
  libuuid,
  mount,
  versionCheckHook,
  # This is for nvidia-container-cli
  nvidia-docker,
  openssl,
  squashfsTools,
  squashfuse,
  # Test dependencies
  singularity-tools,
  cowsay,
  hello,
  # Overridable configurations
  enableNvidiaContainerCli ? true,
  # --nvccli currently requires extra privileges:
  # https://github.com/apptainer/apptainer/issues/1893#issuecomment-1881240800
  forceNvcCli ? false,
  # Compile with seccomp support
  # SingularityCE 3.10.0 and above requires explicit --without-seccomp when libseccomp is not available.
  enableSeccomp ? true,
  # Whether the configure script treat SUID support as default
  # When equal to enableSuid, it suppress the --with-suid / --without-suid build flag
  # It can be set to `null` to always pass either --with-suid or --without-suided
  # Type: null or boolean
  defaultToSuid ? true,
  # Whether to compile with SUID support
  enableSuid ? false,
  starterSuidPath ? null,
  # Extra system-wide /**/bin paths to prefix,
  # useful to specify directories containing binaries with SUID bit set.
  # The paths take higher precedence over the FHS system PATH specified
  # inside the upstream source code.
  # Include "/run/wrappers/bin" by default for the convenience of NixOS users.
  systemBinPaths ? [ "/run/wrappers/bin" ],
  # External LOCALSTATEDIR
  externalLocalStateDir ? null,
  # Remove the symlinks to `singularity*` when projectName != "singularity"
  removeCompat ? false,
  # The defaultPath values to substitute in each source files.
  #
  # `defaultPath` are PATH variables hard-coded inside Apptainer/Singularity
  # binaries to search for third-party utilities, as a hardening for
  # `$out/bin/starter-suid`.
  #
  # The upstream provided values are suitable for FHS-conformant environment.
  # We substitute them and insert Nixpkgs-specific values.
  #
  # Example:
  # {
  #   "path/to/source/file1" = [ "<originalDefaultPath11>" "<originalDefaultPath12>" ... ];
  # }
  sourceFilesWithDefaultPaths ? { },
}:

let
  addShellDoubleQuotes = s: lib.escapeShellArg ''"'' + s + lib.escapeShellArg ''"'';
in
(buildGoModule {
  inherit pname version src;

  patches = lib.optionals (projectName == "apptainer") [
    (replaceVars ./apptainer/0001-ldCache-patch-for-driverLink.patch {
      inherit (addDriverRunpath) driverLink;
    })
  ];

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
  # Optional dependencies.
  # Formatting: Optional dependencies are likely to increase.
  # Don't squash them into the same line.
  ++ lib.optional enableNvidiaContainerCli nvidia-docker
  ++ lib.optional enableSeccomp libseccomp;

  configureScript = "./mconfig";

  configureFlags = [
    "--localstatedir=${
      if externalLocalStateDir != null then externalLocalStateDir else "${placeholder "out"}/var/lib"
    }"
    "--runstatedir=/var/run"
  ]
  ++ lib.optional (!enableSeccomp) "--without-seccomp"
  ++ lib.optional (enableSuid != defaultToSuid) (
    if enableSuid then "--with-suid" else "--without-suid"
  )
  ++ extraConfigureFlags;

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  # Packages to provide fallback bin paths
  # to the Apptainer/Singularity container runtime default PATHs.
  # Override with `<pkg>.overrideAttrs`.
  defaultPathInputs = [
    bash
    coreutils
    cryptsetup # cryptsetup
    fakeroot
    fuse2fs # Mount ext3 filesystems
    go
    mount # mount
    squashfsTools # mksquashfs unsquashfs # Make / unpack squashfs image
    squashfuse # squashfuse_ll squashfuse # Mount (without unpacking) a squashfs image without privileges
  ]
  ++ lib.optional enableNvidiaContainerCli nvidia-docker;

  postPatch = ''
    if [[ ! -e .git || ! -e VERSION ]]; then
      echo "${version}" > VERSION
    fi

    # Patch shebangs for script run during build
    patchShebangs --build "$configureScript" makeit e2e scripts mlocal/scripts

    # Patching the hard-coded defaultPath by prefixing the packages in defaultPathInputs
    ${lib.concatMapAttrsStringSep "\n" (fileName: originalDefaultPaths: ''
      substituteInPlace ${lib.escapeShellArg fileName} \
        ${lib.concatMapStringsSep " \\\n  " (
          originalDefaultPath:
          lib.concatStringsSep " " [
            "--replace-fail"
            (addShellDoubleQuotes (lib.escapeShellArg originalDefaultPath))
            (addShellDoubleQuotes ''$systemDefaultPath''${systemDefaultPath:+:}${lib.escapeShellArg originalDefaultPath}''${inputsDefaultPath:+:}$inputsDefaultPath'')
          ]
        ) originalDefaultPaths}
    '') sourceFilesWithDefaultPaths}
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
      --replace-fail "/usr/bin/env ${projectName}" "$out/bin/${projectName}"

    # Respect PATH from the environment/the user.
    # Fallback to bin paths provided by Nixpkgs packages.
    wrapProgram "$out/bin/${projectName}" \
      --suffix PATH : "$systemDefaultPath" \
      --suffix PATH : "$inputsDefaultPath"

    # Make changes in the config file
    ${lib.optionalString forceNvcCli ''
      substituteInPlace "$out/etc/${projectName}/${projectName}.conf" \
        --replace-fail "use nvidia-container-cli = no" "use nvidia-container-cli = yes"
    ''}
    ${lib.optionalString (enableNvidiaContainerCli && projectName == "singularity") ''
      substituteInPlace "$out/etc/${projectName}/${projectName}.conf" \
        --replace-fail "# nvidia-container-cli path =" "nvidia-container-cli path = ${nvidia-docker}/bin/nvidia-container-cli"
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
    ${lib.optionalString enableSuid (
      lib.warnIf (starterSuidPath == null)
        "${projectName}: Null starterSuidPath when enableSuid produces non-SUID-ed starter-suid and run-time permission denial."
        ''
          chmod +x $out/libexec/${projectName}/bin/starter-suid
        ''
    )}
    ${lib.optionalString (enableSuid && (starterSuidPath != null)) ''
      mv "$out"/libexec/${projectName}/bin/starter-suid{,.orig}
      ln -s ${lib.escapeShellArg starterSuidPath} "$out/libexec/${projectName}/bin/starter-suid"
    ''}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${projectName}";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Application containers for linux" + extraDescription;
    longDescription = ''
      Singularity (the upstream) renamed themselves to Apptainer
      to distinguish themselves from a fork made by Sylabs Inc.. See

      https://sylabs.io/2021/05/singularity-community-edition
      https://apptainer.org/news/community-announcement-20211130
    '';
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jbedo
      ShamrockLee
    ];
    mainProgram = projectName;
  }
  // extraMeta;
}).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      systemDefaultPath = lib.concatStringsSep ":" systemBinPaths;
      inputsDefaultPath = lib.makeBinPath finalAttrs.defaultPathInputs;
      passthru = prevAttrs.passthru or { } // {
        inherit sourceFilesWithDefaultPaths;
        tests = {
          image-hello-cowsay = singularity-tools.buildImage {
            name = "hello-cowsay";
            contents = [
              hello
              cowsay
            ];
            singularity = finalAttrs.finalPackage;
          };
        };
        gpuChecks = lib.optionalAttrs (projectName == "apptainer") {
          # Should be in tests, but Ofborg would skip image-hello-cowsay because
          # saxpy is unfree.
          image-saxpy = callPackage (
            { singularity-tools, cudaPackages }:
            singularity-tools.buildImage {
              name = "saxpy";
              contents = [ cudaPackages.saxpy ];
              memSize = 2048;
              diskSize = 2048;
              singularity = finalAttrs.finalPackage;
            }
          ) { };
          saxpy = callPackage (
            { runCommand, writeShellScriptBin }:
            let
              unwrapped = writeShellScriptBin "apptainer-cuda-saxpy" ''
                ${lib.getExe finalAttrs.finalPackage} exec --nv $@ ${finalAttrs.passthru.gpuChecks.image-saxpy} saxpy
              '';
            in
            runCommand "run-apptainer-cuda-saxpy"
              {
                requiredSystemFeatures = [ "cuda" ];
                nativeBuildInputs = [ unwrapped ];
                passthru = {
                  inherit unwrapped;
                };
              }
              ''
                apptainer-cuda-saxpy
              ''
          ) { };
        };
      };
    }
  )

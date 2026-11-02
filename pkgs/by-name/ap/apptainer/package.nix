{
  lib,
  buildGoModule,
  fetchFromGitHub,
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
  squashfs-tools,
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
  defaultToSuid ? null,
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
  sourceFilesWithDefaultPaths ? {
    "cmd/internal/cli/actions.go" = [ "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin" ];
    "e2e/env/env.go" = [ "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" ];
    "internal/pkg/util/env/env.go" = [ "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" ];
  },
}:

let
  addShellDoubleQuotes = s: lib.escapeShellArg ''"'' + s + lib.escapeShellArg ''"'';
in
buildGoModule (
  finalAttrs:
  let
    # Internal use only; subject to changes.
    # TODO: Remove and hardcode projectName as "apptainer"
    # after `singularity` package removal.
    projectName = finalAttrs.passthru.projectName;
  in
  {
    pname = "apptainer";
    version = "1.5.5";

    src = fetchFromGitHub {
      owner = "apptainer";
      repo = "apptainer";
      tag = "v${finalAttrs.version}";
      hash = "sha256-oV1LzCBYbMFbKGhli6eCbpMoyB1KeccnaEi+xHJ431g=";
    };

    # Override vendorHash with overrideAttrs.
    # See https://nixos.org/manual/nixpkgs/unstable/#buildGoModule-vendorHash
    vendorHash = "sha256-k0HhLDImOs+nDn7B3VfxORnWRxTRlefi01YQiaNASeY=";

    patches = [
      (replaceVars ./0001-ldCache-patch-for-driverLink.patch {
        inherit (addDriverRunpath) driverLink;
      })
    ];

    # go is used to compile extensions when building container images
    allowGoReference = true;

    __structuredAttrs = true;

    passthru = {
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
      cryptsetup
      gpgme
      libuuid
      openssl
      squashfs-tools # Required at build time by SingularityCE
    ]
    # Optional dependencies.
    # Formatting: Optional dependencies are likely to increase.
    # Don't squash them into the same line.
    ++ lib.optional finalAttrs.enableNvidiaContainerCli nvidia-docker
    ++ lib.optional finalAttrs.enableSeccomp libseccomp;

    configureScript = "./mconfig";

    configureFlags = [
      "--localstatedir=${
        if finalAttrs.externalLocalStateDir != null then
          finalAttrs.externalLocalStateDir
        else
          "${placeholder "out"}/var/lib"
      }"
      "--runstatedir=/var/run"
    ]
    ++ lib.optional (!finalAttrs.enableSeccomp) "--without-seccomp"
    ++ lib.optional (finalAttrs.enableSuid != finalAttrs.defaultToSuid) (
      if finalAttrs.enableSuid then "--with-suid" else "--without-suid"
    );

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
      squashfs-tools # mksquashfs unsquashfs # Make / unpack squashfs image
      squashfuse # squashfuse_ll squashfuse # Mount (without unpacking) a squashfs image without privileges
    ]
    ++ lib.optional finalAttrs.enableNvidiaContainerCli nvidia-docker;

    prePatch = ''
      systemDefaultPath=$(concatStringsSep ":" systemBinPaths)
    '';

    postPatch = ''
      if [[ ! -e .git || ! -e VERSION ]]; then
        echo "${finalAttrs.version}" > VERSION
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
              (addShellDoubleQuotes "$systemDefaultPath\${systemDefaultPath:+:}${lib.escapeShellArg originalDefaultPath}\${inputsDefaultPath:+:}$inputsDefaultPath")
            ]
          ) originalDefaultPaths}
      '') finalAttrs.sourceFilesWithDefaultPaths}
    '';

    postConfigure = ''
      # set to empty if unset
      : ''${configureFlags=}

      $configureScript -V ${finalAttrs.version} "''${prefixKey:---prefix=}$prefix" "''${configureFlags[@]}"
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
      ${lib.optionalString finalAttrs.forceNvcCli ''
        substituteInPlace "$out/etc/${projectName}/${projectName}.conf" \
          --replace-fail "use nvidia-container-cli = no" "use nvidia-container-cli = yes"
      ''}
      ${lib.optionalString (finalAttrs.enableNvidiaContainerCli && projectName == "singularity") ''
        substituteInPlace "$out/etc/${projectName}/${projectName}.conf" \
          --replace-fail "# nvidia-container-cli path =" "nvidia-container-cli path = ${nvidia-docker}/bin/nvidia-container-cli"
      ''}
      ${lib.optionalString (finalAttrs.removeCompat && (projectName != "singularity")) ''
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
      ${lib.optionalString finalAttrs.enableSuid (
        lib.warnIf (finalAttrs.starterSuidPath == null)
          "${projectName}: Null starterSuidPath when enableSuid produces non-SUID-ed starter-suid and run-time permission denial."
          ''
            chmod +x $out/libexec/${projectName}/bin/starter-suid
          ''
      )}
      ${lib.optionalString (finalAttrs.enableSuid && (finalAttrs.starterSuidPath != null)) ''
        mv "$out"/libexec/${projectName}/bin/starter-suid{,.orig}
        ln -s ${lib.escapeShellArg finalAttrs.starterSuidPath} "$out/libexec/${projectName}/bin/starter-suid"
      ''}
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgram = "${placeholder "out"}/bin/${projectName}";
    doInstallCheck = true;

    inherit
      defaultToSuid
      enableNvidiaContainerCli
      enableSeccomp
      enableSuid
      externalLocalStateDir
      forceNvcCli
      removeCompat
      sourceFilesWithDefaultPaths
      starterSuidPath
      systemBinPaths
      ;
    inputsDefaultPath = lib.makeBinPath finalAttrs.defaultPathInputs;

    passthru = {
      projectName = "apptainer";
      tests = {
        image-hello-cowsay = singularity-tools.buildImage {
          name = "hello-cowsay";
          contents = [
            hello
            cowsay
          ];
          # mksquashfs scales its memory requirement with the number of
          # processors (all host CPUs by default). Give the build VM enough
          # memory to cope with high core-count builders.
          memSize = 4096;
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

    meta = {
      description = "Application containers for linux";
      longDescription = ''
        Apptainer is a runtime for its squashfs-based container format SIF.
        The SIF container itself is immutable at run time, all mutable parts are bind-mounted.
        It doesn't isolate container processes from the outside environment,
        and don't rely on a privileged daemon like Docker does.

        For historical reasons below, Apptainer is also known as Singularity.

        Naming history and its forks:
        * Singularity, the former name of Apptainer, was born from a research project.
          It was packaged in Nixpkgs as `singularity`.
          * Kurtzer GM, Sochat V, Bauer MW (2017)
            Singularity: Scientific containers for mobility of compute.
            PLoS ONE 12(5): e0177459.
            https://doi.org/10.1371/journal.pone.0177459
        * One of the original Singularity developer found a company called Sylabs Inc.
          to provided a central container repository Singularity Hub.
          Its Python client was packaged in Nixpkgs as `spython`.
        * Sylabs Inc. forked the community-maintained Singularity as SingularityCE,
          and created their commercial version SingularityPRO
        * Singularity renamed themselves to Apptainer
          to distinguish themselves from a fork made by Sylabs Inc..
          Nixpkgs name Apptainer as `apptainer` and SingularityCE as `singularity`.
          * https://sylabs.io/2021/05/singularity-community-edition
          * https://apptainer.org/news/community-announcement-20211130
        * Sylabs merged SingularityPRO into SingulaityCE 4.6.0 and announced EOL of both forks.
      '';
      homepage = "https://apptainer.org";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        jbedo
        ShamrockLee
      ];
      mainProgram = projectName;
    };
  }
)

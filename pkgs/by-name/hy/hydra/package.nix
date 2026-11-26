{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  nixVersions,
  nix-eval-jobs,
  nixosTests,
  perlPackages,
  buildEnv,
  unstableGitUpdater,

  makeWrapper,
  mdbook,
  meson,
  ninja,
  nukeReferences,
  unzip,

  perl,

  gitMinimal,
}:

let
  # Keep in sync with the nix input of https://github.com/NixOS/hydra/blob/master/flake.nix
  nixComponents = nixVersions.nixComponents_2_35;

  version = "0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "e181b587af32365897c215c443b0389657bfdc23";
    hash = "sha256-KlxcjZs0EKhvAggPeTtr2vMj4hQUaTzdJCbL1HR+f6c=";
  };

  # Which programs each of Hydra's programs runs, as `HYDRA_PROGRAM_<NAME>` variables.
  hydraPrograms = callPackage ./programs.nix {
    nix = nixComponents.nix-cli;
    git = gitMinimal;
  };

  # Every script meson installs, except `hydra-dev-server`.
  scripts = [
    "hydra-backfill-ids"
    "hydra-create-user"
    "hydra-fetch-input"
    "hydra-init"
    "hydra-notify"
    "hydra-prepare-declarative-jobset"
    "hydra-s3-backup-collect-garbage"
    "hydra-send-stats"
    "hydra-server"
    "hydra-update-gc-roots"
    "nix-prefetch-bzr"
    "nix-prefetch-git"
    "nix-prefetch-hg"
  ];

  nix-perl = callPackage ./nix-perl.nix {
    inherit src;
    inherit (nixComponents) nix-store;
  };

  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths = lib.closePropagation (
      [
        gitMinimal
        nix-perl
      ]
      ++ (with perlPackages; [
        AuthenSASL
        CacheFastMmap
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystAuthenticationStoreLDAP
        CatalystDevel
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCache
        CatalystPluginCaptcha
        CatalystPluginPrometheusTiny
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginStackTrace
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXRoleApplicator
        CatalystXScriptServerStarman
        CryptPassphrase
        CryptJWT
        CryptPassphraseArgon2
        CryptRandPasswd
        CryptURandom
        DataDump
        DateTime
        DBDPg
        DBDSQLite
        DBIxClassHelpers
        DigestSHA1
        EmailMIME
        EmailSender
        FileCopyRecursive
        FileLibMagic
        FileSlurper
        FileWhich
        IOCompress
        IPCRun
        IPCRun3
        JSON
        JSONMaybeXS
        JSONXS
        ListSomeUtils
        LWP
        LWPProtocolHttps
        ModulePluggable
        NetAmazonS3
        NetPrometheus
        NetStatsd
        NumberBytesHuman
        PadWalker
        ParallelForkManager
        PrometheusTinyShared
        ReadonlyX
        SetScalar
        SQLSplitStatement
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermSizeAny
        TermReadKey
        Test2Harness
        TestPostgreSQL
        TextDiff
        TextTable
        URIdb
        UUIDURandom
        WWWMechanize
        XMLSimple
        YAML
      ])
    );
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hydra";
  inherit version src;
  # nixpkgs-update: no auto update

  sourceRoot = "${finalAttrs.src.name}/subprojects/hydra";

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    mdbook
    meson
    ninja
    nukeReferences
    perl
    perlDeps
    unzip
  ];

  buildInputs = [
    perl
    perlDeps
  ];

  mesonBuildType = "release";

  postPatch = ''
    patchShebangs .
  '';

  # Tests live in subprojects/hydra-tests and need PostgreSQL plus the Rust
  # daemons. Covered by nixosTests.hydra instead.
  doCheck = false;

  # subprojects/hydra-manual is a separate meson project upstream.
  postBuild = ''
    mdbook build ../../hydra-manual -d "$NIX_BUILD_TOP/manual"
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/hydra $out/nix-support
    cp -r $NIX_BUILD_TOP/manual/. $doc/share/doc/hydra
    echo "doc manual $doc/share/doc/hydra" >> $out/nix-support/hydra-build-products
  ''
  # Upstream installs the scripts unwrapped in libexec, and finds every program
  # they run through its own `HYDRA_PROGRAM_<NAME>` variable rather than `PATH`.
  + ''
    for script in $out/libexec/hydra/script/*; do
      if [[ " ${toString scripts} " != *" $(basename "$script") "* ]]; then
        echo "$script is not wrapped, add it to \`scripts'"
        exit 1
      fi
    done

    mkdir -p $out/bin
  ''
  + lib.concatMapStrings (
    script:
    lib.escapeShellArgs (
      [
        "makeWrapper"
        "${placeholder "out"}/libexec/hydra/script/${script}"
        "${placeholder "out"}/bin/${script}"
        "--prefix"
        "PERL5LIB"
        ":"
        "${placeholder "out"}/libexec/hydra/lib:${perlPackages.makePerlPath [ perlDeps ]}"
        "--set-default"
        "HYDRA_RELEASE"
        finalAttrs.version
        "--set"
        "HYDRA_HOME"
        "${placeholder "out"}/libexec/hydra"
        "--set"
        "NIX_RELEASE"
        (nixComponents.nix-cli.name or "unknown")
        "--set"
        "NIX_EVAL_JOBS_RELEASE"
        (nix-eval-jobs.name or "unknown")
      ]
      ++ lib.concatLists (
        lib.mapAttrsToList
          (name: value: [
            "--set"
            name
            value
          ])
          (
            hydraPrograms.envFor {
              localPath = name: "${placeholder "out"}/bin/${name}";
            } hydraPrograms.programs.${script}
          )
      )
    )
    + "\n"
  ) scripts;

  passthru = {
    inherit hydraPrograms nix-perl perlDeps;
    nix = nixComponents.nix-cli;
    tests = { inherit (nixosTests) hydra; };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Nix-based continuous build system";
    homepage = "https://nixos.org/hydra";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      conni2461
      das_j
      helsinki-Jo
      mindavi
    ];
  };
})

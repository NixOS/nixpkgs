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

  bzip2,
  perl,
  pixz,

  coreutils,
  findutils,
  gnused,
  gnutar,
  gzip,
  openssh,
  xz,

  breezy,
  darcs,
  gitMinimal,
  mercurial,
  subversion,
  top-git,

  cdrkit,
  dpkg,
  rpm,
}:

let
  # Keep in sync with the nix input of https://github.com/NixOS/hydra/blob/master/flake.nix
  nixComponents = nixVersions.nixComponents_2_35;

  version = "0-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "588f42497842e9c0172067c8156f8d1b1ea691ff";
    hash = "sha256-GifY4tTG00WPp8RZCFqv/quwuG9rxwuGmTyAUbAgEJ0=";
  };

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

  hydraPath = lib.makeBinPath (
    [
      breezy
      bzip2
      coreutils
      darcs
      findutils
      gitMinimal
      gnused
      gnutar
      gzip
      mercurial
      nix-eval-jobs
      nixComponents.nix-cli
      openssh
      pixz
      subversion
      top-git
      unzip
      xz
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      cdrkit
      dpkg
      rpm
    ]
  );

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

    for i in $out/bin/*; do
        read -n 4 chars < $i
        if [[ $chars =~ ELF ]]; then continue; fi
        wrapProgram $i \
            --prefix PERL5LIB ':' "$out/libexec/hydra/lib:${perlPackages.makePerlPath [ perlDeps ]}" \
            --prefix PATH ':' "$out/bin:$hydraPath" \
            --set-default HYDRA_RELEASE ${finalAttrs.version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nixComponents.nix-cli.name or "unknown"} \
            --set NIX_EVAL_JOBS_RELEASE ${nix-eval-jobs.name or "unknown"}
    done
  '';

  passthru = {
    inherit nix-perl perlDeps;
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

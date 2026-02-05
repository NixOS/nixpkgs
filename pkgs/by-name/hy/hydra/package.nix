{
  stdenv,
  lib,
  nixVersions,
  perlPackages,
  buildEnv,
  makeWrapper,
  unzip,
  pkg-config,
  libpqxx,
  top-git,
  mercurial,
  darcs,
  subversion,
  breezy,
  openssl,
  bzip2,
  libxslt,
  perl,
  postgresql,
  prometheus-cpp,
  nukeReferences,
  git,
  nlohmann_json,
  openssh,
  openldap,
  gnused,
  coreutils,
  findutils,
  gzip,
  xz,
  gnutar,
  rpm,
  dpkg,
  cdrkit,
  pixz,
  boost,
  mdbook,
  foreman,
  python3,
  netcat,
  cacert,
  glibcLocales,
  meson,
  ninja,
  nix-eval-jobs,
  fetchFromGitHub,
  nixosTests,
  unstableGitUpdater,
}:

let
  nix = nixVersions.nix_2_33;

  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths =
      with perlPackages;
      lib.closePropagation [
        AuthenSASL
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystAuthenticationStoreLDAP
        CatalystDevel
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCaptcha
        CatalystPluginPrometheusTiny
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginStackTrace
        CatalystRuntime
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXScriptServerStarman
        CatalystXRoleApplicator
        CryptPassphrase
        CryptPassphraseArgon2
        CryptRandPasswd
        DBDPg
        DBDSQLite
        DBIxClassHelpers
        DataDump
        DateTime
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
        PerlCriticCommunity
        PrometheusTinyShared
        ReadonlyX
        SQLSplitStatement
        SetScalar
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermSizeAny
        TermReadKey
        Test2Harness
        TestPostgreSQL
        TextDiff
        TextTable
        UUID4Tiny
        XMLSimple
        YAML
        (nix.libs.nix-perl-bindings or nix.perl-bindings or null)
        git
      ];
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "hydra";
  version = "0-unstable-2026-01-23";
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "8bc95a96f787eb36f29ceec773f5bf48bd121097";
    hash = "sha256-Ro+qOHWmWuKJiUwX8bmNuGpb0cLUaPr0vsuZGAi2QCI=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    unzip
    libpqxx
    top-git
    mercurial
    darcs
    subversion
    breezy
    openssl
    bzip2
    libxslt
    nix
    perlDeps
    perl
    pixz
    boost
    nlohmann_json
    prometheus-cpp
  ];

  hydraPath = lib.makeBinPath (
    [
      subversion
      openssh
      nix
      nix-eval-jobs
      coreutils
      findutils
      pixz
      gzip
      bzip2
      xz
      gnutar
      unzip
      git
      top-git
      mercurial
      darcs
      gnused
      breezy
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      rpm
      dpkg
      cdrkit
    ]
  );

  nativeBuildInputs = [
    meson
    ninja
    makeWrapper
    pkg-config
    mdbook
    nukeReferences
  ];

  nativeCheckInputs = [
    cacert
    foreman
    glibcLocales
    python3
    netcat
    nix-eval-jobs
    openldap
    postgresql
  ];

  env = {
    OPENLDAP_ROOT = openldap;
  };

  shellHook = ''
    PATH=$(pwd)/src/script:$(pwd)/src/hydra-queue-runner:$(pwd)/src/hydra-evaluator:$PATH
    PERL5LIB=$(pwd)/src/lib:$PERL5LIB;
  '';

  mesonBuildType = "release";

  postPatch = ''
    patchShebangs .
  '';

  preCheck = ''
    export LOGNAME=''${LOGNAME:-foo}
    # set $HOME for bzr so it can create its trace file
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mkdir -p $out/nix-support
    for i in $out/bin/*; do
        read -n 4 chars < $i
        if [[ $chars =~ ELF ]]; then continue; fi
        wrapProgram $i \
            --prefix PERL5LIB ':' "$out/libexec/hydra/lib:${perlPackages.makePerlPath [ perlDeps ]}" \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set-default HYDRA_RELEASE ${finalAttrs.version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nix.name or "unknown"} \
            --set NIX_EVAL_JOBS_RELEASE ${nix-eval-jobs.name or "unknown"}
    done
  '';

  doCheck = true;

  passthru = {
    inherit nix perlDeps;
    tests = { inherit (nixosTests) hydra; };
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Nix-based continuous build system";
    homepage = "https://nixos.org/hydra";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      conni2461
      das_j
      helsinki-Jo
      mindavi
    ];
  };
})

{
  stdenv,
  lib,
  nix,
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
  libressl,
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
        TestSimple13
        TextDiff
        TextTable
        UUID4Tiny
        XMLSimple
        YAML
        (nix.libs.nix-perl-bindings or nix.perl-bindings)
        git
      ];
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "hydra";
  version = "0-unstable-2025-06-15";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "ed500ca4345f7edaa6c3d84027a7599d38b15a29";
    hash = "sha256-Mxz4n40VKxA2ILtIHX6fObgcy2WlgsM+ERfpjuVJ0BU=";
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
    libressl.nc
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

  meta = with lib; {
    description = "Nix-based continuous build system";
    homepage = "https://nixos.org/hydra";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mindavi ];
    teams = [ teams.helsinki-systems ];
  };
})

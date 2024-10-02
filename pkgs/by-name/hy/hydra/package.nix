{ stdenv
, lib
, nix
, perlPackages
, buildEnv
, makeWrapper
, unzip
, pkg-config
, libpqxx
, top-git
, mercurial
, darcs
, subversion
, breezy
, openssl
, bzip2
, libxslt
, perl
, postgresql
, prometheus-cpp
, nukeReferences
, git
, nlohmann_json
, docbook_xsl
, openssh
, openldap
, gnused
, coreutils
, findutils
, gzip
, xz
, gnutar
, rpm
, dpkg
, cdrkit
, pixz
, boost
, autoreconfHook
, mdbook
, foreman
, python3
, libressl
, cacert
, glibcLocales
, fetchFromGitHub
, nixosTests
, unstableGitUpdater
}:

let
  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths = with perlPackages; lib.closePropagation
      [
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
        DataDump
        DateTime
        DigestSHA1
        EmailMIME
        EmailSender
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
        nix.perl-bindings
        git
      ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hydra";
  version = "0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "44248d3cf4162944ec2e6a45f8cc058758bf5a86";
    hash = "sha256-WJ7M/1a8j5gRJJVzCJL6JrkGPckD5ZhKzTlmiKNdtm0=";
  };

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
    postgresql
    nlohmann_json
    prometheus-cpp
  ];

  hydraPath = lib.makeBinPath (
    [
      subversion
      openssh
      nix
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
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [ rpm dpkg cdrkit ]
  );

  nativeBuildInputs = [
    autoreconfHook
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
    openldap
  ];

  configureFlags = [ "--with-docbook-xsl=${docbook_xsl}/xml/xsl/docbook" ];

  env = {
    NIX_CFLAGS_COMPILE = "-pthread";
    OPENLDAP_ROOT = openldap;
  };

  shellHook = ''
    PATH=$(pwd)/src/script:$(pwd)/src/hydra-eval-jobs:$(pwd)/src/hydra-queue-runner:$(pwd)/src/hydra-evaluator:$PATH
    PERL5LIB=$(pwd)/src/lib:$PERL5LIB;
  '';

  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs .
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
            --prefix PERL5LIB ':' $out/libexec/hydra/lib:$PERL5LIB \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set-default HYDRA_RELEASE ${finalAttrs.version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nix.name or "unknown"}
    done
  '';

  doCheck = true;

  passthru = {
    inherit nix perlDeps;
    tests.basic = nixosTests.hydra.hydra;
    updateScript = unstableGitUpdater {};
  };

  meta = with lib; {
    description = "Nix-based continuous build system";
    homepage = "https://nixos.org/hydra";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mindavi ] ++ teams.helsinki-systems.members;
  };
})

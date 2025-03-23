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
, mdbook
, foreman
, python3
, libressl
, cacert
, glibcLocales
, meson
, ninja
, nix-eval-jobs
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
        nix.perl-bindings
        git
      ];
  };

  nix-eval-jobs' = nix-eval-jobs.overrideAttrs (_: {
    version = "2.25.0-unstable-2025-02-13";
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nix-eval-jobs";
      rev = "6d4fd5a93d7bc953ffa4dcd6d53ad7056a71eff7";
      hash = "sha256-1dZLPw+nlFQzzswfyTxW+8VF1AJ4ZvoYvLTjlHiz1SA=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hydra";
  version = "0-unstable-2025-02-12";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "c6f98202cd1b091475ae51b6a093d00b4c8060d4";
    hash = "sha256-CEDUtkA005PiLt1wSo3sgmxfxUBikQSE74ZudyWNxfE=";
  };

  outputs = [ "out" "doc" ];

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
      nix-eval-jobs'
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
    nix-eval-jobs'
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
            --prefix PERL5LIB ':' $out/libexec/hydra/lib:$PERL5LIB \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set-default HYDRA_RELEASE ${finalAttrs.version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nix.name or "unknown"} \
            --set NIX_EVAL_JOBS_RELEASE ${nix-eval-jobs'.name or "unknown"}
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

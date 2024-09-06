{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, makeBinaryWrapper
, perl
, ghostscript
, nixosTests
}:

buildNpmPackage rec {
  pname = "lanraragi";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "Difegue";
    repo = "LANraragi";
    rev = "v.${version}";
    hash = "sha256-2YdQeBW1MQiUs5nliloISaxG0yhFJ6ulkU/Urx8PN3Y=";
  };

  patches = [
    ./install.patch
    ./fix-paths.patch
    ./expose-password-hashing.patch # Used by the NixOS module
  ];

  npmDepsHash = "sha256-RAjZGuK0C6R22fVFq82GPQoD1HpRs3MYMluUAV5ZEc8=";

  nativeBuildInputs = [ perl makeBinaryWrapper ];

  buildInputs = with perl.pkgs; [
    perl
    ImageMagick
    locallib
    Redis
    Encode
    ArchiveLibarchiveExtract
    ArchiveLibarchivePeek
    ListMoreUtils
    NetDNSNative
    SortNaturally
    AuthenPassphrase
    FileReadBackwards
    URI
    LogfileRotate
    Mojolicious
    MojoliciousPluginTemplateToolkit
    MojoliciousPluginRenderFile
    MojoliciousPluginStatus
    IOSocketSocks
    IOSocketSSL
    CpanelJSONXS
    Minion
    MinionBackendRedis
    ProcSimple
    ParallelLoops
    SysCpuAffinity
    FileChangeNotify
    ModulePluggable
    TimeLocal
    YAMLPP
    StringSimilarity
  ] ++ lib.optionals stdenv.isLinux [ LinuxInotify2 ];

  buildPhase = ''
    runHook preBuild

    # Check if every perl dependency was installed
    # explicitly call cpanm with perl because the shebang is broken on darwin
    perl ${perl.pkgs.Appcpanminus}/bin/cpanm --installdeps ./tools --notest

    perl ./tools/install.pl install-full
    rm -r node_modules public/js/vendor/*.map public/css/vendor/*.map

    runHook postBuild
  '';

  doCheck = true;

  nativeCheckInputs = with perl.pkgs; [
    TestMockObject
    TestTrap
    TestDeep
  ];

  checkPhase = ''
    runHook preCheck

    rm tests/plugins.t # Uses network
    prove -r -l -v tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lanraragi
    chmod +x script/launcher.pl
    cp -r lib public script templates package.json lrr.conf $out/share/lanraragi

    makeWrapper $out/share/lanraragi/script/launcher.pl $out/bin/lanraragi \
      --prefix PERL5LIB : $PERL5LIB \
      --prefix PATH : ${lib.makeBinPath [ ghostscript ]} \
      --run "cp -n --no-preserve=all $out/share/lanraragi/lrr.conf ./lrr.conf 2>/dev/null || true" \
      --add-flags "-f $out/share/lanraragi/script/lanraragi"

    makeWrapper ${lib.getExe perl} $out/bin/helpers/lrr-make-password-hash \
      --prefix PERL5LIB : $out/share/lanraragi/lib:$PERL5LIB \
      --add-flags "-e 'use LANraragi::Controller::Config; print LANraragi::Controller::Config::make_password_hash(@ARGV[0])' 2>/dev/null"

    runHook postInstall
  '';

  passthru.tests.module = nixosTests.lanraragi;

  meta = {
    changelog = "https://github.com/Difegue/LANraragi/releases/tag/${src.rev}";
    description = "Web application for archival and reading of manga/doujinshi";
    homepage = "https://github.com/Difegue/LANraragi";
    license = lib.licenses.mit;
    mainProgram = "lanraragi";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}

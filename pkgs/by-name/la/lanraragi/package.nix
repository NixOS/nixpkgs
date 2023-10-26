{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, fetchpatch
, makeBinaryWrapper
, perl
, ghostscript
, nixosTests
}:

let
  cpanDeps = with perl.pkgs; [
    ImageMagick
    locallib
    Redis
    Encode
    ArchiveLibarchiveExtract
    ArchiveLibarchivePeek
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
  ] ++ lib.optional stdenv.isLinux LinuxInotify2;
in
buildNpmPackage rec {
  pname = "lanraragi";
  version = "0.8.90";

  src = fetchFromGitHub {
    owner = "Difegue";
    repo = "LANraragi";
    rev = "v.${version}";
    hash = "sha256-ljnREUGCKvUJvcQ+aJ6XqiMTkVmfjt/0oC47w3PCj/k=";
  };

  patches = [
    # fetchpatch entries can be removed when updating to 0.9.0
    (fetchpatch {
      name = "add-package-lock-json.patch";
      url = "https://github.com/Difegue/LANraragi/commit/c5cd8641795bf7e40deef4ae955ea848dde44050.patch";
      hash = "sha256-XKxRzeugkIe6N4XRN6+O1wEZpxo6OzU0OaG0ywKFv38=";
    })
    (fetchpatch {
      name = "fix-minion-redis-password.patch";
      url = "https://github.com/Difegue/LANraragi/commit/9277b620be29ad6f8fd6ebdf9d9169c68d30abce.patch";
      hash = "sha256-asUy0N6PvEC1BCESpfZyl5G9f2SvVvSLOjE17ef+fAg=";
    })
    (fetchpatch {
      name = "update-secret-generation.patch"; # security patch
      url = "https://github.com/Difegue/LANraragi/compare/9277b620be29ad6f8fd6ebdf9d9169c68d30abce..d6da3f0c4736c5bc45410043dfe40d2c5b917198.patch";
      hash = "sha256-Dlz5CfQPVwasySOI/PsuvcYpRXicUa45o/RtfXd4aVE=";
      includes = [ "lib/LANraragi.pm" ];
    })
    ./install.patch
    ./loosen-dep-reqs.patch
    ./fix-paths.patch
    ./expose-password-hashing.patch
  ];

  npmFlags = [ "--legacy-peer-deps" ];

  npmDepsHash = "sha256-UQsChPU5b4+r5Kv6P/3rJCGUzssiUNSKo3w4axNyJew=";

  nativeBuildInputs = [ perl makeBinaryWrapper ];

  buildInputs = [ perl ] ++ cpanDeps;

  buildPhase = ''
    runHook preBuild

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

    # Check if every dependency was installed
    # explicitly call cpanm with perl as the shebang is broken on darwin
    perl ${lib.getExe perl.pkgs.Appcpanminus} --installdeps ./tools --notest

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


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
  perlEnv = perl.withPackages (_: cpanDeps);

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
    (fetchpatch {
      name = "add-package-lock-json.patch"; # Can be removed when updating to 0.9.0
      url = "https://github.com/Difegue/LANraragi/commit/c5cd8641795bf7e40deef4ae955ea848dde44050.patch";
      hash = "sha256-XKxRzeugkIe6N4XRN6+O1wEZpxo6OzU0OaG0ywKFv38=";
    })
    ./install.patch
    ./fix-paths.patch
    ./expose-password-hashing.patch
    ./fix-minion-redis-password.patch # Should be upstreamed
  ];

  npmFlags = [ "--legacy-peer-deps" ];

  npmDepsHash = "sha256-UQsChPU5b4+r5Kv6P/3rJCGUzssiUNSKo3w4axNyJew=";

  nativeBuildInputs = [
    perl
    makeBinaryWrapper
    perl.pkgs.Appcpanminus
  ] ++ cpanDeps;

  nativeCheckInputs = with perl.pkgs; [
    TestMockObject
    TestTrap
    TestDeep
  ];

  buildPhase = ''
    runHook preBuild

    perl ./tools/install.pl install-full
    rm -r node_modules public/js/vendor/*.map public/css/vendor/*.map

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    rm tests/plugins.t # Uses network
    prove -r -l -v tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lanraragi
    cp -r lib public script templates package.json $out/share/lanraragi

    makeWrapper ${perlEnv}/bin/perl $out/bin/lanraragi \
      --prefix PATH : ${lib.makeBinPath [ ghostscript ]} \
      --add-flags "$out/share/lanraragi/script/launcher.pl -f $out/share/lanraragi/script/lanraragi"

    runHook postInstall
  '';

  passthru = {
    inherit perlEnv;
    tests = { inherit (nixosTests) lanraragi; };
  };

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

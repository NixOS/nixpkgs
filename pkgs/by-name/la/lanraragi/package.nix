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

buildNpmPackage rec {
  pname = "lanraragi";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Difegue";
    repo = "LANraragi";
    rev = "v.${version}";
    hash = "sha256-euZotpXTUSmxlA5rbTUhHpHH0Ojd3AZjGasxYZ+L7NY=";
  };

  patches = [
    (fetchpatch {
      name = "fix-redis-auth.patch";
      url = "https://github.com/Difegue/LANraragi/commit/1711b39759ad02ab2a8863ce1f35f6479c9a2917.patch";
      hash = "sha256-WfKeieysIlS64qgVEc75JFKjxXuvZN85M6US/gwjTzw=";
    })
    (fetchpatch {
      name = "fix-ghostscript-device.patch";
      url = "https://github.com/Difegue/LANraragi/commit/087d63b11c89fda8cb3a30cdb2e86ecd6be66bb7.patch";
      hash = "sha256-Cu9d/dDlO0yuFCTKOyg5A0gIuiA+FcWD9PjexB/BK0U=";
    })
    ./install.patch
    ./fix-paths.patch
    ./expose-password-hashing.patch # Used by the NixOS module
  ];

  npmDepsHash = "sha256-/F/lhQIVGbbFxFuQXXwHUVlV2jhHt0hFf94v0FrTKt8=";

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
    YAMLSyck
    StringSimilarity
  ] ++ lib.optional stdenv.isLinux LinuxInotify2;

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


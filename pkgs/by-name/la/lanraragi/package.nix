{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  perl,
  ghostscript,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "lanraragi";
  version = "0.9.50";

  src = fetchFromGitHub {
    owner = "Difegue";
    repo = "LANraragi";
    tag = "v.${version}";
    hash = "sha256-WwAY74sFPFJNfrTcGfXEZE8svuOxoCXR70SFyHb2Y40=";
  };

  patches = [
    # https://github.com/Difegue/LANraragi/pull/1340
    # Note: the PR was reverted upstream because it broke on windows
    ./bail-if-cpanm-fails.patch

    # Skip running `npm ci` and unnecessary build-time checks
    ./install.patch

    # Don't assume that the cwd is $out/share/lanraragi
    # Put logs and temp files into the cwd by default, instead of into $out/share/lanraragi
    ./fix-paths.patch

    # Expose the password hashing logic that can be used by the NixOS module
    # to set the admin password
    ./expose-password-hashing.patch
  ];

  npmDepsHash = "sha256-+vS/uoEmJJM3G9jwdwQTlhV0VkjAhhVd60x+PcYyWSw=";

  nativeBuildInputs = [
    perl
    perl.pkgs.Appcpanminus
    makeBinaryWrapper
  ];

  buildInputs =
    with perl.pkgs;
    # deps listed in `tools/cpanfile`:
    [
      perl
      locallib
      Redis
      Encode
      ArchiveLibarchiveExtract
      ArchiveLibarchivePeek
      ArchiveZip
      # Digest::SHA (part of perl)
      ListMoreUtils
      SortNaturally
      AuthenPassphrase
      FileReadBackwards
      # URI::Escape (part of URI)
      URI
      # IPC::Cmd (part of perl)
      # Compress::Zlib (part of perl)
      Mojolicious
      MojoliciousPluginTemplateToolkit
      MojoliciousPluginRenderFile
      IOSocketSocks
      IOSocketSSL
      CpanelJSONXS
      Minion
      MinionBackendRedis
      ProcSimple
      ParallelLoops
      MCE # (has MCE::Loop)
      MCEShared
      SysCpuAffinity
      FileChangeNotify
      ModulePluggable
      TimeLocal
      YAMLPP
      StringSimilarity
      # Locale::Maketext (part of perl)
      LocaleMaketextLexicon
      CHI
      # CHI::Driver::FastMmap (part of CHI)
      CacheFastMmap
    ]
    # deps listed in `tools/install.pm`:
    ++ [
      ImageMagick
      NetDNSNative
      MojoliciousPluginStatus
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      LinuxInotify2
    ];

  buildPhase = ''
    runHook preBuild

    perl ./tools/install.pl install-full
    rm public/js/vendor/*.map public/css/vendor/*.map

    runHook postBuild
  '';

  doCheck = true;

  nativeCheckInputs = with perl.pkgs; [
    # App::Prove (part of perl)
    # Test::Harness (part of perl)
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
    cp -r lib public script locales templates package.json lrr.conf $out/share/lanraragi

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
    changelog = "https://github.com/Difegue/LANraragi/releases/tag/${src.tag}";
    description = "Web application for archival and reading of manga/doujinshi";
    homepage = "https://github.com/Difegue/LANraragi";
    license = lib.licenses.mit;
    mainProgram = "lanraragi";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}

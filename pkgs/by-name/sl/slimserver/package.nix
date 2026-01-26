{
  faad2,
  fetchFromGitHub,
  flac,
  lame,
  lib,
  makeWrapper,
  monkeysAudio,
  nixosTests,
  perlPackages,
  sox,
  stdenv,
  wavpack,
  zlib,
  enableUnfreeFirmware ? false,
}:

let
  binPath = lib.makeBinPath (
    [
      lame
      flac
      faad2
      sox
      wavpack
    ]
    ++ (lib.optional stdenv.hostPlatform.isLinux monkeysAudio)
  );

  libPath = lib.makeLibraryPath [
    zlib
    stdenv.cc.cc
  ];
in
perlPackages.buildPerlPackage rec {
  pname = "slimserver";
  version = "9.0.3";

  src = fetchFromGitHub {
    owner = "LMS-Community";
    repo = "slimserver";
    tag = version;
    hash = "sha256-Yc/XBINSX1JN7lJn4fin4qcTUSF8Bg+FbFe23KlYkfs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # slimserver vendors quite a few CPAN packages
  # this list is intended to only replace compiled modules
  # which can be found in CPAN/arch in the slimserver repo
  # replacements are added here AND removed in prePatch to
  # avoid module mismatches
  buildInputs =
    with perlPackages;
    [
      AudioScan
      ClassXSAccessor
      DBDSQLite
      DBI
      DigestSHA1
      EncodeDetect
      EV
      HTMLParser
      ImageScale
      IOAIO
      IOInterface
      IOSocketSSL
      JSONXS
      JSONXSVersionOneAndTwo
      MP3CutGapless
      SubName
      TemplateToolkit
      XMLParser
      YAMLLibYAML
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      LinuxInotify2
    ];

  prePatch = ''
    # remove vendored binaries
    rm -rf Bin

    # remove precompiled cpan modules
    rm -rf CPAN/arch
    # remove the precompiled modules, they come from buildInputs
    rm -rf CPAN/Class/XSAccessor{,.pm}
    rm -rf CPAN/DBD{,.pm}
    rm -rf CPAN/DBI{,.pm}
    rm -rf CPAN/Digest/SHA1{,.pm}
    rm -rf CPAN/Encode/Detect{,.pm}
    rm -rf CPAN/HTML/Parser{,.pm}
    rm -rf CPAN/Image{,.pm}
    rm -rf CPAN/IO/AIO{,.pm}
    rm -rf CPAN/IO/Interface{,.pm}
    rm -rf CPAN/JSON/XS{,.pm}
    rm -rf CPAN/MP3/Cut/Gapless{,.pm}
    rm -rf CPAN/Sub/Name{,.pm}
    rm -rf CPAN/XML/Parser{,.pm}
    rm -rf CPAN/YAML/XS{,.pm}

    # there's also a copy of AudioScan in lib...
    rm -rf lib/Audio

    ${lib.optionalString (!enableUnfreeFirmware) ''
      # remove unfree firmware
      rm -rf Firmware
    ''}

    touch Makefile.PL
  '';

  doCheck = false;

  installPhase = ''
    cp -r . $out
    wrapProgram $out/slimserver.pl --prefix LD_LIBRARY_PATH : "${libPath}" --prefix PATH : "${binPath}"
    chmod +x $out/scanner.pl
    wrapProgram $out/scanner.pl --prefix LD_LIBRARY_PATH : "${libPath}" --prefix PATH : "${binPath}"
    mkdir $out/bin
    ln -s $out/slimserver.pl $out/bin/slimserver
  '';

  outputs = [ "out" ];

  passthru = {
    tests = {
      inherit (nixosTests) slimserver;
    };

    updateScript = ./update.nu;
  };

  meta = {
    homepage = "https://lyrion.org/";
    changelog = "https://lyrion.org/getting-started/changelog-lms${lib.versions.major version}";
    description = "Lyrion Music Server (formerly Logitech Media Server) is open-source server software which controls a wide range of Squeezebox audio players";
    # the firmware is not under a free license, so we do not include firmware in the default package
    # https://github.com/LMS-Community/slimserver/blob/public/8.3/License.txt
    license = if enableUnfreeFirmware then lib.licenses.unfree else lib.licenses.gpl2Only;
    mainProgram = "slimserver";
    maintainers = with lib.maintainers; [
      adamcstephens
      jecaro
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}

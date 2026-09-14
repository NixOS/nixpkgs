{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libGL,
  libpng,
  libjpeg,
  libx11,
  SDL2_ttf,
  libvorbis,
  gettext,
  physfs,
  curl,
  iconv,
  makeBinaryWrapper,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neverball";
  version = "1.7.0-alpha.3";

  src = fetchFromGitHub {
    owner = "Neverball";
    repo = "neverball";
    tag = finalAttrs.version;
    hash = "sha256-C6zXAQEjaiuo3v/ihvyXnJhK0kTPzC0sxLOgY9bFdgk=";
  };

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      iconv
      makeBinaryWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ];

  buildInputs = [
    libpng
    SDL2
    libGL
    libjpeg
    SDL2_ttf
    libvorbis
    gettext
    physfs
    curl
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libx11
  ];

  dontPatchELF = true;

  postPatch = ''
    substituteInPlace share/base_config.h Makefile \
      --replace-fail './data' "$out/share/neverball/data" \
      --replace-fail './locale' "$out/share/neverball/locale"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace-fail '-lvorbisfile' '-lvorbisfile -liconv'

    for game in ball putt; do
      pushd macosx/xcode/''${game}_items/
        substituteInPlace Info.plist --replace-fail '1.5.3' "$version"
        iconv -f UTF-16LE -t UTF-8 English.lproj/InfoPlist.strings > English.lproj/InfoPlist.strings.tmp

        substituteInPlace English.lproj/InfoPlist.strings.tmp --replace-fail '1.5.3' "$version"
        iconv -f UTF-8 -t UTF-16LE English.lproj/InfoPlist.strings.tmp > English.lproj/InfoPlist.strings

        rm English.lproj/InfoPlist.strings.tmp
      popd
    done
  '';

  # The map generation code requires a writable HOME
  preConfigure = "export HOME=$TMPDIR";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/neverball
    cp -R data locale $out/share/neverball

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications/Never{ball,putt}.app/Contents/{MacOS,Resources}

      for game in ball putt; do
        cp never$game $out/Applications/Never$game.app/Contents/MacOS/Never$game
        makeWrapper $out/Applications/Never$game.app/Contents/MacOS/Never$game $out/bin/never$game
        cp macosx/xcode/''${game}_items/Info.plist $out/Applications/Never$game.app/Contents/Info.plist
        cp -r macosx/icons/never$game.icns macosx/xcode/''${game}_items/English.lproj $out/Applications/Never$game.app/Contents/Resources/
      done
    ''}

    cp mapc $out/bin;

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 dist/neverball.desktop.in $out/share/applications/neverball.desktop
      install -Dm644 dist/neverputt.desktop.in $out/share/applications/neverputt.desktop

      for size in 16 24 32 48 64 128 256 512; do
          install -Dm644 dist/neverputt_''${size}.png \
            $out/share/icons/hicolor/''${size}x''${size}/apps/neverputt.png
      done

      install -Dm644 dist/neverball.appdata.xml $out/share/metainfo/neverball.metainfo.xml
    ''}

    install -Dm644 dist/neverball.6 $out/share/man/man6/neverball.6
    install -Dm644 dist/neverputt.6 $out/share/man/man6/neverputt.6
    install -Dm644 dist/mapc.1 $out/share/man/man1/mapc.1

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://neverball.org/";
    description = "Tilt the floor to roll a ball";
    changelog = "https://github.com/Neverball/neverball/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Plus
      ijg
      mit
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      Rhys-T
      philocalyst
    ];
    platforms = with lib.platforms; linux ++ darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})

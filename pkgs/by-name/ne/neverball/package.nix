{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  SDL2,
  libGL,
  libpng,
  libjpeg,
  libX11,
  SDL2_ttf,
  libvorbis,
  gettext,
  physfs,
  iconv,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neverball";
  version = "1.6.0";
  src = fetchurl {
    url = "https://neverball.org/neverball-${finalAttrs.version}.tar.gz";
    sha256 = "184gm36c6p6vaa6gwrfzmfh86klhnb03pl40ahsjsvprlk667zkk";
  };
  patches = [
    # Pull upstream fix for -fno-common toolchains
    #   https://github.com/Neverball/neverball/pull/198
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/Neverball/neverball/commit/a42492b8db06934c7a794630db92e3ff6ebaadaa.patch";
      sha256 = "0sqyxfwpl4xxra8iz87j5rxzwani16xra2xl4l5z61shvq30308h";
    })
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    iconv
    makeBinaryWrapper
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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libX11
  ];

  dontPatchELF = true;

  postPatch = ''
    sed -i -e 's@\./data@'$out/share/neverball/data@ share/base_config.h Makefile
    sed -i -e 's@\./locale@'$out/share/neverball/locale@ share/base_config.h Makefile
    sed -i -e 's@-lvorbisfile@-lvorbisfile${
      lib.optionalString (!stdenv.hostPlatform.isDarwin) " -lX11"
      + lib.optionalString stdenv.cc.isGNU " -lgcc_s"
    }@' Makefile
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    for game in ball putt; do
      pushd macosx/xcode/''${game}_items/
      substituteInPlace Info.plist --replace-fail '1.5.3' "$version"
      iconv -f UTF-16LE -t UTF-8 English.lproj/InfoPlist.strings > English.lproj/InfoPlist.strings.tmp
      substituteInPlace English.lproj/InfoPlist.strings.tmp --replace-fail '1.5.3' "$version" --replace-fail '2002-2009' '2002-2014'
      iconv -f UTF-8 -t UTF-16LE English.lproj/InfoPlist.strings.tmp > English.lproj/InfoPlist.strings
      rm English.lproj/InfoPlist.strings.tmp
      popd
    done
  '';

  # The map generation code requires a writable HOME
  preConfigure = "export HOME=$TMPDIR";

  installPhase = ''
    mkdir -p $out/bin $out/share/neverball
    cp -R data locale $out/share/neverball
    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications/Never{ball,putt}.app/Contents/{MacOS,Resources}
          for game in ball putt; do
            cp never$game $out/Applications/Never$game.app/Contents/MacOS/Never$game
            makeWrapper $out/Applications/Never$game.app/Contents/MacOS/Never$game $out/bin/never$game
            cp macosx/xcode/''${game}_items/Info.plist $out/Applications/Never$game.app/Contents/Info.plist
            cp -r macosx/icons/never$game.icns macosx/xcode/''${game}_items/English.lproj $out/Applications/Never$game.app/Contents/Resources/
          done
        ''
      else
        ''
          cp neverball $out/bin
          cp neverputt $out/bin
        ''
    }
    cp mapc $out/bin
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://neverball.org/";
    description = "Tilt the floor to roll a ball";
    license = with lib.licenses; [
      gpl2Plus
      ijg
      mit
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ Rhys-T ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})

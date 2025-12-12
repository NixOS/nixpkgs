{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  boost,
  portmidi,
  sqlite,
  freetype,
  libpng,
  pngpp,
  zlib,
  wxGTK32,
  wxsqlite3,
  fluidsynth,
  fontconfig,
  soundfont-fluid,
  openlilylib-fonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lenmus";
  version = "6.0.1-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "lenmus";
    repo = "lenmus";
    rev = "113787fe4d755e7e406b5ea4bd2cfb9eae0e56a3";
    hash = "sha256-tDvSgdeFx5xEjExnDhoXgvuvk7+oEPgbt4DJajckvLc=";
  };

  env = {
    NIX_CFLAGS_COMPILE = "-fpermissive";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr" "${placeholder "out"}"
    sed -i 's/fixup_bundle.*")/")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
  ];

  buildInputs = [
    boost
    portmidi
    sqlite
    freetype
    libpng
    pngpp
    zlib
    wxGTK32
    wxsqlite3
    fluidsynth
    fontconfig
  ];

  preConfigure = ''
    mkdir res/fonts
    ln -s ${openlilylib-fonts.bravura}/share/lilypond/*/fonts/otf/Bravura.otf res/fonts/Bravura.otf
    ln -s ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2 res/sounds/FluidR3_GM.sf2
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DLENMUS_INSTALL_SOUNDFONT=ON"
    "-DMAN_INSTALL_DIR=${placeholder "out"}/share/man"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/lenmus.app $out/Applications
    mv $out/Resources $out/Applications/lenmus.app/Contents
    makeWrapper $out/{Applications/lenmus.app/Contents/MacOS,bin}/lenmus
  '';

  meta = {
    description = "Program for learning music";
    longDescription = ''
      LenMus Phonascus is a free open source program (GPL v3) for learning music.
      It allows you to focus on specific skills and exercises, on both theory and aural training.
      The different activities can be customized to meet your needs
    '';
    homepage = "http://www.lenmus.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ramkromberg ];
    platforms = lib.platforms.unix;
    mainProgram = "lenmus";
  };
})

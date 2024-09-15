{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, boost
, portmidi
, sqlite
, freetype
, libpng
, pngpp
, zlib
, wxGTK32
, wxsqlite3
, fluidsynth
, fontconfig
, darwin
, soundfont-fluid
, openlilylib-fonts
}:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation rec {
  pname = "lenmus";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "lenmus";
    repo = "lenmus";
    rev = "Release_${version}";
    sha256 = "sha256-qegOAc6vs2+6VViDHVjv0q+qjLZyTT7yPF3hFpTt5zE=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr" "${placeholder "out"}"
    sed -i 's/fixup_bundle.*")/")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
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
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/lenmus.app $out/Applications
    mv $out/Resources $out/Applications/lenmus.app/Contents
    makeWrapper $out/{Applications/lenmus.app/Contents/MacOS,bin}/lenmus
  '';

  meta = with lib; {
    description = "LenMus Phonascus is a program for learning music";
    longDescription = ''
      LenMus Phonascus is a free open source program (GPL v3) for learning music.
      It allows you to focus on specific skills and exercises, on both theory and aural training.
      The different activities can be customized to meet your needs
    '';
    homepage = "http://www.lenmus.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers;  [ ramkromberg ];
    platforms = with platforms; unix;
    mainProgram = "lenmus";
  };
}

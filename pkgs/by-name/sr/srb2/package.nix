{ lib
, stdenv
, fetchgit
, fetchFromGitHub
, cmake
, curl
, nasm
, libopenmpt
, game-music-emu
, libGLU
, libpng
, SDL2
, SDL2_mixer
, zlib
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srb2";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "SRB2";
    rev = "SRB2_release_${finalAttrs.version}";
    hash = "sha256-OSkkjCz7ZW5+0vh6l7+TpnHLzXmd/5QvTidRQSHJYX8=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    curl
    game-music-emu
    libpng
    libopenmpt
    SDL2
    SDL2_mixer
    zlib
  ];

  assets = stdenv.mkDerivation {
    pname = "srb2-data";
    version = finalAttrs.version;

    src = fetchgit {
      url = "https://git.do.srb2.org/STJr/srb2assets-public";
      rev = "SRB2_release_${finalAttrs.version}";
      hash = "sha256-OXvO5ZlujIYmYevc62Dtx192dxoujQMNFUCrH5quBBg=";
      fetchLFS = true;
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/srb2
      cp -r * $out/share/srb2

      runHook postInstall
    '';
  };

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${finalAttrs.assets}/share/srb2"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2.dev}/include/SDL2"
  ];

  patches = [
    # Make the build work without internet connectivity
    # See: https://build.opensuse.org/request/show/1109889
    ./cmake.patch
    ./thirdparty.patch
  ];

  postPatch = ''
    substituteInPlace ./src/sdl/ogl_sdl.c \
      --replace libGLU.so.1 ${libGLU}/lib/libGLU.so.1
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "Sonic Robo Blast 2";
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      comment = finalAttrs.meta.description;
      desktopName = name;
      genericName = name;
      categories = [ "Game" ];
      startupWMClass = ".srb2-wrapped";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/share/icons

    copyDesktopItems

    cp ../srb2.png $out/share/pixmaps/.
    cp ../srb2.png $out/share/icons/.

    cp bin/lsdlsrb2 $out/bin/srb2
    wrapProgram $out/bin/srb2 --set SRB2WADDIR "${finalAttrs.assets}/share/srb2"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sonic Robo Blast 2 is a 3D Sonic the Hedgehog fangame based on a modified version of Doom Legacy";
    homepage = "https://www.srb2.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zeratax donovanglover ];
    mainProgram = "srb2";
  };
})

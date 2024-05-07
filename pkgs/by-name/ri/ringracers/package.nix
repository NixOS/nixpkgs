{ lib
, stdenv
, fetchzip
, fetchFromGitHub
, cmake
, curl
, nasm
, ninja
, libpng
, libogg
, libvorbis
, libvpx
, libyuv
, SDL2
, tree
, zlib
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ringracers";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "KartKrewDev";
    repo = "RingRacers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mvRa2Kc9t++IuAXFnplvLKiUQv4uPohay0NG9kr9UQs=";
  };

  assets = stdenv.mkDerivation {
    pname = "ringracers-data";
    version = finalAttrs.version;

    src = fetchzip {
      url = "https://github.com/KartKrewDev/RingRacers/releases/download/v${finalAttrs.version}/Dr.Robotnik.s-Ring-Racers-v${finalAttrs.version}-Assets.zip";
      hash = "sha256-Flfrv1vbL8NeN3sxafsHuqPPaxZMgvvohizXefUFoVg=";
      stripRoot = false;
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/ringracers
      cp -r * $out/share/ringracers

      runHook postInstall
    '';
  };

  nativeBuildInputs = [
    cmake
    nasm
    ninja
    makeWrapper
    copyDesktopItems
    tree
  ];

  buildInputs = [
    curl
    zlib
    libpng
    libogg
    libvorbis
    libvpx
    libyuv
    SDL2
  ];

  # TODO: There are multiple available CMake presets available,
  #       including some for Darwin and MinGW. Use the correct
  #       preset according to Nix configuration options.
  configurePhase = ''
    cmake --preset ninja-release
  '';

  buildPhase = ''
    cmake --build --preset ninja-release
  '';

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${finalAttrs.assets}/share/ringracers"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2}/include/SDL2"
  ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "Dr. Robotnik's Ring Racers";
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      comment = "Racing at the Next Level";
      desktopName = name;
      genericName = name;
      startupWMClass = ".ringracers-wrapped";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 srb2.png $out/share/pixmaps/ringracers.png
    install -Dm644 srb2.png $out/share/icons/ringracers.png
    install -Dm755 build/ninja-release/bin/ringracers $out/bin/ringracers

    wrapProgram $out/bin/ringracers \
      --set RINGRACERSWADDIR "${finalAttrs.assets}/share/ringracers"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dr. Robotnik's Ring Racers is a classic styled kart racer";
    homepage = "https://www.kartkrew.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thehans255 ];
    mainProgram = "ringracers";
  };
})

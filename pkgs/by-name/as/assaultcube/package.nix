{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  openal,
  pkg-config,
  libogg,
  libvorbis,
  SDL2,
  SDL2_image,
  makeWrapper,
  zlib,
  file,
  client ? true,
  server ? true,
}:

stdenv.mkDerivation rec {
  pname = "assaultcube";
  version = "1.3.0.2";

  src = fetchFromGitHub {
    owner = "assaultcube";
    repo = "AC";
    rev = "v${version}";
    sha256 = "0qv339zw9q5q1y7bghca03gw7z4v89sl4lbr6h3b7siy08mcwiz9";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    copyDesktopItems
  ];

  buildInputs =
    [
      file
      zlib
    ]
    ++ lib.optionals client [
      openal
      SDL2
      SDL2_image
      libogg
      libvorbis
    ];

  targets = (lib.optionalString server "server") + (lib.optionalString client " client");
  makeFlags = [
    "-C source/src"
    "CXX=${stdenv.cc.targetPrefix}c++"
    targets
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "AssaultCube";
      comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
      genericName = "First-person shooter";
      categories = [
        "Game"
        "ActionGame"
        "Shooter"
      ];
      icon = "assaultcube";
      exec = pname;
    })
  ];

  gamedatadir = "/share/games/${pname}";

  installPhase = ''
    runHook preInstall

    bindir=$out/bin

    mkdir -p $bindir $out/$gamedatadir

    cp -r config packages $out/$gamedatadir

    if (test -e source/src/ac_client) then
      cp source/src/ac_client $bindir
      mkdir -p $out/share/applications
      install -Dpm644 packages/misc/icon.png $out/share/icons/assaultcube.png
      install -Dpm644 packages/misc/icon.png $out/share/pixmaps/assaultcube.png

      makeWrapper $out/bin/ac_client $out/bin/${pname} \
        --chdir "$out/$gamedatadir" --add-flags "--home=\$HOME/.assaultcube/v1.2next --init"
    fi

    if (test -e source/src/ac_server) then
      cp source/src/ac_server $bindir
      makeWrapper $out/bin/ac_server $out/bin/${pname}-server \
        --chdir "$out/$gamedatadir" --add-flags "-Cconfig/servercmdline.txt"
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = "https://assault.cubers.net";
    platforms = platforms.linux; # should work on darwin with a little effort.
    license = licenses.unfree;
    maintainers = with maintainers; [ darkonion0 ];
  };
}

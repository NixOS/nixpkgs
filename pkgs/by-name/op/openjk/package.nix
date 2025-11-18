{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  cmake,
  libjpeg,
  zlib,
  libpng,
  libGL,
  libX11,
  SDL2,
  unstableGitUpdater,
}:

let
  jamp = makeDesktopItem rec {
    name = "jamp";
    exec = name;
    icon = "OpenJK_Icon_128";
    comment = "Open Source Jedi Academy game released by Raven Software";
    desktopName = "Jedi Academy (Multi Player)";
    genericName = "Jedi Academy";
    categories = [ "Game" ];
  };
  jasp = makeDesktopItem rec {
    name = "jasp";
    exec = name;
    icon = "OpenJK_Icon_128";
    comment = "Open Source Jedi Academy game released by Raven Software";
    desktopName = "Jedi Academy (Single Player)";
    genericName = "Jedi Academy";
    categories = [ "Game" ];
  };
  josp = makeDesktopItem rec {
    name = "josp";
    exec = name;
    icon = "OpenJK_Icon_128";
    comment = "Open Source Jedi Outcast game released by Raven Software";
    desktopName = "Jedi Outcast (Single Player)";
    genericName = "Jedi Outcast";
    categories = [ "Game" ];
  };
in
stdenv.mkDerivation {
  pname = "openjk";
  version = "0-unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "JACoders";
    repo = "OpenJK";
    rev = "d1cb662f07dfa4c1999edfb5c1a86fd1c6285372";
    hash = "sha256-XTGe/V4FnQSQA9fY6MmpECs1f2PPk+yTZkAL93UoH/I=";
  };

  dontAddPrefix = true;

  nativeBuildInputs = [
    makeWrapper
    cmake
  ];
  buildInputs = [
    libjpeg
    zlib
    libpng
    libGL
    libX11
    SDL2
  ];

  outputs = [
    "out"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "openjo"
    "openja"
  ];

  # move from $out/JediAcademy to $out/opt/JediAcademy
  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$out/opt")
  '';
  cmakeFlags = [
    "-DBuildJK2SPEngine:BOOL=ON"
    "-DBuildJK2SPGame:BOOL=ON"
    "-DBuildJK2SPRdVanilla:BOOL=ON"
  ]
  # Otherwise will fall with `not found <fp.h>`
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DUseInternalJPEG:BOOL=OFF"
    "-DUseInternalPNG:BOOL=OFF"
  ];

  postInstall =
    if stdenv.hostPlatform.isLinux then
      ''
        mkdir -p $out/bin $openja/bin $openjo/bin
        mkdir -p $openja/share/applications $openjo/share/applications
        mkdir -p $openja/share/icons/hicolor/128x128/apps $openjo/share/icons/hicolor/128x128/apps
        mkdir -p $openja/opt $openjo/opt
        mv $out/opt/JediAcademy $openja/opt/
        mv $out/opt/JediOutcast $openjo/opt/
        jaPrefix=$openja/opt/JediAcademy
        joPrefix=$openjo/opt/JediOutcast

        makeWrapper $jaPrefix/openjk.* $openja/bin/jamp --chdir "$jaPrefix"
        makeWrapper $jaPrefix/openjk_sp.* $openja/bin/jasp --chdir "$jaPrefix"
        makeWrapper $jaPrefix/openjkded.* $openja/bin/openjkded --chdir "$jaPrefix"
        makeWrapper $joPrefix/openjo_sp.* $openjo/bin/josp --chdir "$joPrefix"

        cp $src/shared/icons/OpenJK_Icon_128.png $openjo/share/icons/hicolor/128x128/apps
        cp $src/shared/icons/OpenJK_Icon_128.png $openja/share/icons/hicolor/128x128/apps
        ln -s ${jamp}/share/applications/* $openja/share/applications
        ln -s ${jasp}/share/applications/* $openja/share/applications
        ln -s ${josp}/share/applications/* $openjo/share/applications
        ln -s $openja/bin/* $out/bin
        ln -s $openjo/bin/* $out/bin
        rm -rf $out/opt
      ''
    else if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications $out/bin
        mv $out/opt/JediOutcast/openjo_sp.*.app $out/Applications/openjo_sp.app
        mv $out/opt/JediAcademy/openjk.*.app $out/Applications/openjk.app
        mv $out/opt/JediAcademy/openjk_sp.*.app $out/Applications/openjk_sp.app
        mv $out/opt/JediAcademy/openjkded.* $out/bin/openjkded
        rm -rf $out/opt

        makeWrapper $out/Applications/openjk.app/Contents/MacOS/openjk.* $out/bin/openjk \
          --chdir $out/Applications/openjk.app/Contents/MacOS/

        makeWrapper $out/Applications/openjk_sp.app/Contents/MacOS/openjk_sp.* $out/bin/openjk_sp \
          --chdir $out/Applications/openjk_sp.app/Contents/MacOS/

        makeWrapper $out/Applications/openjo_sp.app/Contents/MacOS/openjo_sp.* $out/bin/openjo_sp \
          --chdir $out/Applications/openjo_sp.app/Contents/MacOS/
      ''
    else
      throw "unsupported system";

  # CMake is copying libraries, but their links are needed
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for app in openjk openjk_sp openjo_sp; do
      pushd $out/Applications/$app.app/Contents/Frameworks/

      rm *.dylib
      ln -s ${SDL2}/lib/libSDL2.dylib libSDL2-2.0.0.dylib
      ln -s ${zlib}/lib/libz.dylib libz.dylib

      popd
    done
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Open-source engine for Star Wars Jedi Academy game";
    homepage = "https://github.com/JACoders/OpenJK";
    license = lib.licenses.gpl2Only;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ ];
  };
}

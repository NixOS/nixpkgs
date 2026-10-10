{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  boost,
  cmake,
  libGL,
  libjpeg,
  libpng,
  libx11,
  makeDesktopItem,
  makeWrapper,
  unstableGitUpdater,
  versionCheckHook,
  zlib,
}:

let
  desktopItems = {
    jamp = makeDesktopItem {
      name = "jamp";
      exec = "jamp";
      icon = "openjk";
      comment = "Open Source Jedi Academy game released by Raven Software";
      desktopName = "Jedi Academy (Multi Player)";
      genericName = "Jedi Academy";
      categories = [ "Game" ];
    };
    jasp = makeDesktopItem {
      name = "jasp";
      exec = "jasp";
      icon = "openjk_sp";
      comment = "Open Source Jedi Academy game released by Raven Software";
      desktopName = "Jedi Academy (Single Player)";
      genericName = "Jedi Academy";
      categories = [ "Game" ];
    };
    josp = makeDesktopItem {
      name = "josp";
      exec = "josp";
      icon = "openjo_sp";
      comment = "Open Source Jedi Outcast game released by Raven Software";
      desktopName = "Jedi Outcast (Single Player)";
      genericName = "Jedi Outcast";
      categories = [ "Game" ];
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openjk";
  version = "0-unstable-2026-09-29";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "JACoders";
    repo = "OpenJK";
    rev = "260c59c2907187af555a676fe0cc798893bf7757";
    hash = "sha256-hhktBFCJl4bwJ94XbuB/m+UUJo148fi8i8zYhu0jp7s=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(GIT_TAG vUNKNOWN)" "set(GIT_TAG ${finalAttrs.version})"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libGL
    libjpeg
    libpng
    libx11
    SDL2
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/opt")
    (lib.cmakeBool "BuildJK2SPEngine" true)
    (lib.cmakeBool "BuildJK2SPGame" true)
    (lib.cmakeBool "BuildJK2SPRdVanilla" true)
    (lib.cmakeBool "BuildTests" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "UseInternalJPEG" false)
    (lib.cmakeBool "UseInternalPNG" false)
  ];

  dontAddPrefix = true;
  doCheck = true;
  checkInputs = [ boost ];

  postInstall =
    if stdenv.hostPlatform.isLinux then
      ''
        mkdir -p $out/bin
        rm -rf $out/opt/UnitTests
        jaPrefix=$out/opt/JediAcademy
        joPrefix=$out/opt/JediOutcast

        makeWrapper $jaPrefix/openjk.* $out/bin/jamp --chdir "$jaPrefix"
        makeWrapper $jaPrefix/openjk_sp.* $out/bin/jasp --chdir "$jaPrefix"
        makeWrapper $jaPrefix/openjkded.* $out/bin/openjkded --chdir "$jaPrefix"
        makeWrapper $joPrefix/openjo_sp.* $out/bin/josp --chdir "$joPrefix"

        for size in 16 32 48 64 128 256 512; do
          install -Dm644 $src/shared/icons/PNG/mp$size.png \
            $out/share/icons/hicolor/''${size}x''${size}/apps/openjk.png
          install -Dm644 $src/shared/icons/PNG/sp$size.png \
            $out/share/icons/hicolor/''${size}x''${size}/apps/openjk_sp.png
          install -Dm644 $src/shared/icons/PNG/jo$size.png \
            $out/share/icons/hicolor/''${size}x''${size}/apps/openjo_sp.png
        done

        install -Dm644 -t $out/share/applications \
          ${desktopItems.jamp}/share/applications/* \
          ${desktopItems.jasp}/share/applications/* \
          ${desktopItems.josp}/share/applications/*
      ''
    else if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications $out/bin
        mv $out/opt/JediOutcast/openjo_sp.*.app $out/Applications/openjo_sp.app
        mv $out/opt/JediAcademy/openjk.*.app $out/Applications/openjk.app
        mv $out/opt/JediAcademy/openjk_sp.*.app $out/Applications/openjk_sp.app
        mv $out/opt/JediAcademy/openjkded.* $out/bin/openjkded
        rm -r $out/opt

        makeWrapper $out/Applications/openjk.app/Contents/MacOS/openjk.* $out/bin/openjk \
          --chdir $out/Applications/openjk.app/Contents/MacOS/

        makeWrapper $out/Applications/openjk_sp.app/Contents/MacOS/openjk_sp.* $out/bin/openjk_sp \
          --chdir $out/Applications/openjk_sp.app/Contents/MacOS/

        makeWrapper $out/Applications/openjo_sp.app/Contents/MacOS/openjo_sp.* $out/bin/openjo_sp \
          --chdir $out/Applications/openjo_sp.app/Contents/MacOS/
      ''
    else
      throw "unsupported system";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/openjkded";
  versionCheckProgramArg = "+quit";
  versionCheckKeepEnvironment = [ "HOME" ];

  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for app in openjk openjk_sp openjo_sp; do
      pushd $out/Applications/$app.app/Contents/Frameworks/

      rm *.dylib
      ln -s ${lib.getLib SDL2}/lib/libSDL2.dylib libSDL2-2.0.0.dylib
      ln -s ${lib.getLib zlib}/lib/libz.dylib libz.dylib

      popd
    done
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Open-source engine for Star Wars Jedi Academy game";
    homepage = "https://github.com/JACoders/OpenJK";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})

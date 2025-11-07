{
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  python3,
  qt6Packages,
  radare2,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "iaito";
  version = "6.0.4";

  srcs = [
    (fetchFromGitHub {
      owner = "radareorg";
      repo = "iaito";
      tag = finalAttrs.version;
      hash = "sha256-99SuUTwHcpyJ5V9Cnanm6ylH3NVgyk3TmDoaFVwFE4E=";
      name = "main";
    })
    (fetchFromGitHub {
      owner = "radareorg";
      repo = "iaito-translations";
      rev = "e66b3a962a7fc7dfd730764180011ecffbb206bf";
      hash = "sha256-6NRTZ/ydypsB5TwbivvwOH9TEMAff/LH69hCXTvMPp8=";
      name = "translations";
    })
  ];
  sourceRoot = "main/src";

  postUnpack = ''
    chmod -R u+w translations
  '';

  postPatch = ''
    substituteInPlace common/ResourcePaths.cpp \
      --replace-fail "/app/share/iaito/translations" "$out/share/iaito/translations"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    radare2
  ];

  mesonFlags = [
    "-Dwith_qt6=true"
  ];

  postBuild = ''
    pushd ../../../translations
    make build -j $NIX_BUILD_CORES PREFIX=$out
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -Dt $out/bin iaito
    install -m644 -Dt $out/share/metainfo ../org.radare.iaito.appdata.xml
    install -m644 -Dt $out/share/applications ../org.radare.iaito.desktop
    install -m644 -Dt $out/share/pixmaps ../img/org.radare.iaito.svg

    pushd ../../../translations
    make install -j$NIX_BUILD_CORES PREFIX=$out
    popd

    runHook postInstall
  '';

  meta = {
    description = "Official radare2 GUI";
    longDescription = ''
      iaito is the official graphical interface for radare2, a libre reverse
      engineering framework.
    '';
    homepage = "https://radare.org/n/iaito.html";
    changelog = "https://github.com/radareorg/iaito/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.linux;
    mainProgram = "iaito";
  };
})

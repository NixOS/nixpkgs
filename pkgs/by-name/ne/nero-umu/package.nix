{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  qt6Packages,
  icu,
  icoextract,
  icoutils,
  umu-launcher,
  winetricks,
  curl,
  mangohud,
  gamescope,
  gamemode,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nero-umu";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "SeongGino";
    repo = "Nero-umu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cx2hN5LV7/EOXnn9RfIsj9OmnlM1oMZB7a535/hwTas=";
  };

  #Replace quazip git submodule with pre-packaged quazip
  postUnpack = ''
    rmdir source/lib/quazip/
    ln -s ${qt6Packages.quazip.src} source/lib/quazip
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qt5compat
    qt6Packages.quazip
    icu
  ];

  runtimeDeps = [
    icoextract
    icoutils
    winetricks
    curl
    umu-launcher
    mangohud
    gamescope
    gamemode
  ];

  cmakeFlags = [
    (lib.cmakeFeature "NERO_QT_VERSION" "Qt6")
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 "nero-umu" "$out/bin/nero-umu"
    for size in 32 48 64 128; do
      install -Dm644 "$src/img/ico/ico_"$size".png" "$out/share/icons/hicolor/"$size"x"$size"/apps/xyz.TOS.Nero.png"
    done
    install -Dm644 "$src/xyz.TOS.Nero.desktop" "$out/share/applications/xyz.TOS.Nero.desktop"
    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}
    )
  '';

  meta = {
    homepage = "https://github.com/SeongGino/Nero-umu";
    description = "Fast and efficient Proton prefix runner and manager using umu as backend";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nero-umu";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      ern775
      blghnks
      keenanweaver
    ];
  };
})

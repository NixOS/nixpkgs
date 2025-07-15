{
  boost,
  cmake,
  dbus,
  fetchFromGitHub,
  guiSupport ? true,
  lib,
  libtorrent-rasterbar,
  nix-update-script,
  openssl,
  pkg-config,
  python3,
  qt6,
  stdenv,
  trackerSearch ? true,
  webuiSupport ? true,
  wrapGAppsHook3,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qbittorrent" + lib.optionalString (!guiSupport) "-nox";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qBittorrent";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-2hcG2rMwo5wxVQjCEXXqPLGpdT6ihqtt3HsNlK1D9CA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  buildInputs =
    [
      boost
      libtorrent-rasterbar
      openssl
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      zlib
    ]
    ++ lib.optionals guiSupport [ dbus ]
    ++ lib.optionals (guiSupport && stdenv.hostPlatform.isLinux) [ qt6.qtwayland ]
    ++ lib.optionals trackerSearch [ python3 ];

  cmakeFlags =
    [ "-DVERBOSE_CONFIGURE=ON" ]
    ++ lib.optionals (!guiSupport) [
      "-DGUI=OFF"
      "-DSYSTEMD=ON"
      "-DSYSTEMD_SERVICES_INSTALL_DIR=${placeholder "out"}/lib/systemd/system"
    ]
    ++ lib.optionals (!webuiSupport) [ "-DWEBUI=OFF" ];

  qtWrapperArgs = lib.optionals trackerSearch [ "--prefix PATH : ${lib.makeBinPath [ python3 ]}" ];

  dontWrapGApps = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    APP_NAME=qbittorrent${lib.optionalString (!guiSupport) "-nox"}
    mkdir -p $out/{Applications,bin}
    mv $out/$APP_NAME.app $out/Applications
    makeWrapper $out/{Applications/$APP_NAME.app/Contents/MacOS,bin}/$APP_NAME
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    description = "Featureful free software BitTorrent client";
    homepage = "https://www.qbittorrent.org";
    changelog = "https://github.com/qbittorrent/qBittorrent/blob/release-${finalAttrs.version}/Changelog";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      Anton-Latukha
      kashw2
    ];
    mainProgram = "qbittorrent" + lib.optionalString (!guiSupport) "-nox";
  };
})

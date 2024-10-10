{ lib
, stdenv
, fetchFromGitHub

, boost
, cmake
, Cocoa
, libtorrent-rasterbar
, ninja
, qtbase
, qtsvg
, qttools
, wrapGAppsHook3
, wrapQtAppsHook

, guiSupport ? true
, dbus
, qtwayland

, trackerSearch ? true
, python3

, webuiSupport ? true
}:

let
  qtVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "qbittorrent"
    + lib.optionalString (!guiSupport) "-nox";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qBittorrent";
    rev = "release-${version}";
    hash = "sha256-iwqJaRfwJTL6SimWTNqqqFPXxSKrgo6whYY70llZyGs";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    libtorrent-rasterbar
    qtbase
    qtsvg
    qttools
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
  ] ++ lib.optionals guiSupport [
    dbus
  ] ++ lib.optionals (guiSupport && stdenv.hostPlatform.isLinux) [
    qtwayland
  ] ++ lib.optionals trackerSearch [
    python3
  ];

  cmakeFlags = lib.optionals (!guiSupport) [
    "-DGUI=OFF"
    "-DSYSTEMD=ON"
    "-DSYSTEMD_SERVICES_INSTALL_DIR=${placeholder "out"}/lib/systemd/system"
  ] ++ lib.optionals (!webuiSupport) [
    "-DWEBUI=OFF"
  ];

  qtWrapperArgs = lib.optionals trackerSearch [
    "--prefix PATH : ${lib.makeBinPath [ python3 ]}"
  ];

  dontWrapGApps = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    APP_NAME=qbittorrent${lib.optionalString (!guiSupport) "-nox"}
    mkdir -p $out/{Applications,bin}
    cp -R $APP_NAME.app $out/Applications
    makeWrapper $out/{Applications/$APP_NAME.app/Contents/MacOS,bin}/$APP_NAME
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Featureful free software BitTorrent client";
    homepage = "https://www.qbittorrent.org";
    changelog = "https://github.com/qbittorrent/qBittorrent/blob/release-${version}/Changelog";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Anton-Latukha kashw2 ];
  };
}

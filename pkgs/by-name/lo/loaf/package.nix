{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  ninja,
  qt6,
  libGL,
  p7zip,
  zip,
  shared-mime-info,
}:

let
  qtEnv = qt6.env "qt6-env" [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "loaf";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "m-uvex";
    repo = "loaf-fm";
    rev = "v${version}";
    hash = "sha256-mLlSD2y0mhumk4ZoF+Pu3BWapHMHHDKK2hzI1Jan+Kg=";
  };

  cargoHash = "sha256-6sPIVABm/a0Sf9owtlL2lD84Z8VqPgMwWzj6g0yp2Yo=";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  buildInputs = [
    qtEnv
    libGL
    p7zip
    zip
    shared-mime-info
  ];

  QMAKE = "${qtEnv}/bin/qmake";
  QT_PLUGIN_PATH = "${qtEnv}/lib/qt-6/plugins";
  QML2_IMPORT_PATH = "${qtEnv}/lib/qt-6/qml";
  LD_LIBRARY_PATH = "${lib.makeLibraryPath [
    qtEnv
    libGL
  ]}";
  XDG_DATA_DIRS = "${shared-mime-info}/share";

  postInstall = ''
    install -Dm644 packaging/assets/loaf.desktop $out/share/applications/loaf.desktop
    install -Dm644 packaging/assets/loaf.portal $out/share/xdg-desktop-portal/portals/loaf.portal
    install -Dm644 packaging/assets/org.freedesktop.impl.portal.desktop.loaf.service $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.loaf.service
    substituteInPlace $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.loaf.service \
      --replace-fail "Exec=/usr/bin/loaf" "Exec=$out/bin/loaf"
    mkdir -p $out/share/icons
    cp -r packaging/assets/icons/hicolor $out/share/icons/
  '';

  meta = with lib; {
    description = "Material 3 Expressive file manager in Rust and QML";
    homepage = "https://github.com/m-uvex/loaf-fm";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "loaf";
  };
}

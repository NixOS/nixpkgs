{ lib
, stdenv
, fetchFromGitHub
, cargo
, desktop-file-utils
, glib
, gtk4
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gtksourceview5
, libadwaita
, libpanel
, vte-gtk4
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jSN4WmyzYARhDkwAtTYD4iXNTM1QQbAAwQ/ICHg7k3k=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ashpd-0.6.0" = "sha256-kLacOwMZ4MQlFYCx5J4kI4J+a9fVRF5Ii/AkWOL/TNQ=";
      "cairo-rs-0.19.0" = "sha256-8s+ngacR7d2wb1FKYf0pycxMQbgW63zMKpMgaUs2e+c=";
      "gdk4-0.8.0" = "sha256-o9HC4VX6ntPk0JXAX5Whhu0qlUdpPky/1PNrRd9zjdk=";
      "libadwaita-0.6.0" = "sha256-3Kge7SIE+vex/uOIt7hjmU68jidkBjrW96o24hu3e/U=";
      "libpanel-0.3.0" = "sha256-LA8ynd+7imEdQwvLslmKw+pPNbAEle9fZ2sFuyRY/jU=";
      "podman-api-0.10.0" = "sha256-nbxK/U5G+PlbytpHdr63x/C69hBgedPXBFfgdzT9fdc=";
      "sourceview5-0.8.0" = "sha256-+f+mm682H4eRC7Xzx5wukecDZq+hMpJQ3+3xHzG00Go=";
      "vte4-0.8.0" = "sha256-KZBpfSAngbp5czAXdKA7Au5uYqs2L5MyNsnXcBH77lo=";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
    mainProgram = "pods";
  };
}

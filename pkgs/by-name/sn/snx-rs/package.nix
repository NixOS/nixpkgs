{ fetchFromGitHub
, glib
, gtk3
, iproute2
, kdePackages
, lib
, libappindicator
, libappindicator-gtk2
, libappindicator-gtk3
, libayatana-appindicator
, libsoup
, openssl
, pkg-config
, rustPlatform
, webkitgtk_4_1
}:

rustPlatform.buildRustPackage {
  pname = "snx-rs";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "ancwrd1";
    repo = "snx-rs";
    rev = "v2.8.0";
    hash = "sha256-fVe9+S705AfZHywJgbOg/j1v7zKwiCTW4El3UnI++uA=";
  };

  nativeBuildInputs = [
    iproute2
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    kdePackages.kstatusnotifieritem
    libappindicator
    libappindicator-gtk2
    libappindicator-gtk3
    libayatana-appindicator
    libsoup
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  checkFlags = [
    "--skip=platform::linux::net::tests::test_default_ip"
    "--skip=platform::linux::resolver::tests::test_detect_resolver"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "isakmp-0.1.0" = "sha256-CslJ+E3FRS/R2NcKFNy8nDptLqBcLJ5AcUOaN7zKB8I=";
    };
  };

  meta = {
    description = "Open source Linux client for Checkpoint VPN tunnels";
    homepage = "https://github.com/ancwrd1/snx-rs";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ patryk27 ];
  };
}

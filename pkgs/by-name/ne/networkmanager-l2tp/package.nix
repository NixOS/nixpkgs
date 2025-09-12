{
  stdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gtk3,
  gtk4,
  networkmanager,
  ppp,
  xl2tpd,
  strongswan,
  libsecret,
  withGnome ? true,
  libnma,
  libnma-gtk4,
  glib,
  openssl,
  nss,
}:

stdenv.mkDerivation rec {
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";
  pname = "NetworkManager-l2tp";
  version = "1.20.20";

  src = fetchFromGitHub {
    owner = "nm-l2tp";
    repo = "network-manager-l2tp";
    rev = version;
    hash = "sha256-AmbDWBCUG9fvqA6iJopYtbitdRwv2faWvIeKN90p234=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit strongswan xl2tpd;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    glib # for gdbus-codegen
    pkg-config
  ]
  ++ lib.optionals withGnome [
    gtk4 # for gtk4-builder-tool
  ];

  buildInputs = [
    networkmanager
    ppp
    openssl
    nss
  ]
  ++ lib.optionals withGnome [
    gtk3
    gtk4
    libsecret
    libnma
    libnma-gtk4
  ];

  configureFlags = [
    "--with-gnome=${lib.boolToYesNo withGnome}"
    "--with-gtk4=${lib.boolToYesNo withGnome}"
    "--localstatedir=/var"
    "--enable-absolute-paths"
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru = {
    networkManagerPlugin = "VPN/nm-l2tp-service.name";
  };

  meta = with lib; {
    description = "L2TP plugin for NetworkManager";
    inherit (networkmanager.meta) platforms;
    homepage = "https://github.com/nm-l2tp/network-manager-l2tp";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      obadz
    ];
  };
}

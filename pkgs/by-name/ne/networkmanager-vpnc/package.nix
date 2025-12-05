{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  vpnc,
  pkg-config,
  networkmanager,
  libsecret,
  gtk3,
  gtk4,
  withGnome ? true,
  gnome,
  glib,
  kmod,
  file,
  libnma,
  libnma-gtk4,
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-vpnc";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-vpnc/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "47KpiIAnWht1FUvDF6eGQ8/fnqfnDfTu2WSPKeolNzA=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit vpnc kmod;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    file
    glib
  ];

  buildInputs = [
    vpnc
    networkmanager
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
    "--enable-absolute-paths"
  ];

  strictDeps = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-vpnc";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-vpnc-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's VPNC plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = licenses.gpl2Plus;
  };
}

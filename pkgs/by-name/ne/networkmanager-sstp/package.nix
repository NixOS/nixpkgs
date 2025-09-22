{
  stdenv,
  lib,
  autoreconfHook,
  fetchurl,
  file,
  glib,
  gnome,
  gtk3,
  gtk4,
  gettext,
  libnma,
  libnma-gtk4,
  libsecret,
  networkmanager,
  pkg-config,
  ppp,
  sstp,
  withGnome ? true,
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-sstp";
  version = "1.3.2";
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-zd+g86cZLyibLhYLal6XzUb9wFu7kHROp0KzRM95Qng=";
  };

  nativeBuildInputs = [
    autoreconfHook
    file
    gettext
    glib # for gdbus-codegen
    pkg-config
  ]
  ++ lib.optionals withGnome [
    gtk4 # for gtk4-builder-tool
  ];

  buildInputs = [
    sstp
    networkmanager
    ppp
  ]
  ++ lib.optionals withGnome [
    gtk3
    gtk4
    libsecret
    libnma
    libnma-gtk4
  ];

  postPatch = ''
    sed -i 's#/sbin/pppd#${ppp}/bin/pppd#' src/nm-sstp-service.c
    sed -i 's#/sbin/sstpc#${sstp}/bin/sstpc#' src/nm-sstp-service.c
  '';

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--with-pppd-plugin-dir=$(out)/lib/pppd/2.5.0"
    "--enable-absolute-paths"
  ];

  strictDeps = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-sstp";
    };
    networkManagerPlugin = "VPN/nm-sstp-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's sstp plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = licenses.gpl2Plus;
  };
}

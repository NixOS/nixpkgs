{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  openvpn,
  gettext,
  libxml2,
  pkg-config,
  file,
  networkmanager,
  libsecret,
  glib,
  gtk3,
  gtk4,
  withGnome ? true,
  gnome,
  kmod,
  libnma,
  libnma-gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NetworkManager-openvpn";
  version = "1.12.3";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-openvpn/${lib.versions.majorMinor finalAttrs.version}/NetworkManager-openvpn-${finalAttrs.version}.tar.xz";
    sha256 = "S9ochVm7jDX28THAntrpDN/M0DFOi4y5isVeCbYAWtw=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit kmod openvpn;
    })
  ];

  nativeBuildInputs = [
    gettext
    glib
    pkg-config
    file
    libxml2
  ];

  buildInputs = [
    openvpn
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
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  strictDeps = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "NetworkManager-openvpn";
      attrPath = "networkmanager-openvpn";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-openvpn-service.name";
  };

  meta = {
    description = "NetworkManager's OpenVPN plugin";
    homepage = "https://gitlab.gnome.org/GNOME/NetworkManager-openvpn";
    changelog = "https://gitlab.gnome.org/GNOME/NetworkManager-openvpn/-/blob/main/NEWS";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = lib.licenses.gpl2Plus;
  };
})

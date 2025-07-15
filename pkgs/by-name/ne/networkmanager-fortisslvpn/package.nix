{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  openfortivpn,
  autoreconfHook,
  gettext,
  pkg-config,
  file,
  glib,
  gtk3,
  gtk4,
  networkmanager,
  ppp,
  libsecret,
  withGnome ? true,
  gnome,
  libnma,
  libnma-gtk4,
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-fortisslvpn";
  version = "1.4.0";
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sFXiY0m1FrI1hXmKs+9XtDawFIAOkqiscyz8jnbF2vo=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit openfortivpn;
    })
    ./support-ppp-2.5.0.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    file
    glib
  ];

  buildInputs =
    [
      openfortivpn
      networkmanager
      ppp
      glib
    ]
    ++ lib.optionals withGnome [
      gtk3
      gtk4
      libsecret
      libnma
      libnma-gtk4
    ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--localstatedir=/var"
    "--enable-absolute-paths"
  ];

  installFlags = [
    # the installer only creates an empty directory in localstatedir, so
    # we can drop it
    "localstatedir=."
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-fortisslvpn";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-fortisslvpn-service.name";
    networkManagerTmpfilesRules = [
      "d /var/lib/NetworkManager-fortisslvpn 0700 root root -"
    ];
  };

  meta = with lib; {
    description = "NetworkManager’s FortiSSL plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = licenses.gpl2Plus;
  };
}

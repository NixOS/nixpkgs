{
  stdenv,
  lib,
  fetchurl,
  intltool,
  pkg-config,
  networkmanager,
  strongswanNM,
  gtk3,
  gtk4,
  libsecret,
  libnma,
  libnma-gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NetworkManager-strongswan";
  version = "1.6.4";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/NetworkManager-strongswan-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-X9ftnoogw2W+p9ZTdgoECfmyEkRABtQ2UzK7zFGPbBU=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    networkmanager
    strongswanNM
    libsecret
    gtk3
    gtk4
    libnma
    libnma-gtk4
  ];

  configureFlags = [
    "--disable-more-warnings" # disables -Werror
    "--with-charon=${strongswanNM}/libexec/ipsec/charon-nm"
    "--with-nm-libexecdir=${placeholder "out"}/libexec"
    "--with-nm-plugindir=${placeholder "out"}/lib/NetworkManager"
    "--with-gtk4"
  ];

  env.PKG_CONFIG_LIBNM_VPNSERVICEDIR = "${placeholder "out"}/lib/NetworkManager/VPN";

  passthru = {
    networkManagerPlugin = "VPN/nm-strongswan-service.name";
    networkManagerDbusDeps = [ strongswanNM ];
    networkManagerTmpfilesRules = [
      "d /etc/ipsec.d 0700 root root -"
    ];
  };

  meta = {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
    license = lib.licenses.gpl2Plus;
  };
})

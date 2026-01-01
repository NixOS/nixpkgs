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

stdenv.mkDerivation rec {
  pname = "NetworkManager-strongswan";
<<<<<<< HEAD
  version = "1.6.4";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/${pname}-${version}.tar.bz2";
    sha256 = "sha256-X9ftnoogw2W+p9ZTdgoECfmyEkRABtQ2UzK7zFGPbBU=";
=======
  version = "1.6.2";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/${pname}-${version}.tar.bz2";
    sha256 = "sha256-jL8kf63MsCbTTvYn1M7YbpUOMXPl2h/ZY7Rpz2rAr34=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  env.PKG_CONFIG_LIBNM_VPNSERVICEDIR = "${placeholder "out"}/lib/NetworkManager/VPN";
=======
  PKG_CONFIG_LIBNM_VPNSERVICEDIR = "${placeholder "out"}/lib/NetworkManager/VPN";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    networkManagerPlugin = "VPN/nm-strongswan-service.name";
    networkManagerDbusDeps = [ strongswanNM ];
    networkManagerTmpfilesRules = [
      "d /etc/ipsec.d 0700 root root -"
    ];
  };

<<<<<<< HEAD
  meta = {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

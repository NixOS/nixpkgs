{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, libnl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "hostapd-mana";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    hash = "sha256-co5LMJAUYSdcvhLv1gfjDvdVqdSXgjtFoiQ7+KxR07M=";
  };

  patches = [
    # Fix compile errors with GCC 10 on newer Kali
    (fetchpatch {
      url = "https://github.com/sensepost/hostapd-mana/commit/8581994d8d19646da63e1e37cde27dd4c966e526.patch";
      hash = "sha256-UBkhuqvX1nFiceECAIC9B13ReKbrAAUtPKjqD17mQgg=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libnl openssl ];

  extraConfig = ''
    CONFIG_DRIVER_WIRED=y
    CONFIG_LIBNL32=y
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_EAP_PAX=y
    CONFIG_EAP_PWD=y
    CONFIG_EAP_SAKE=y
    CONFIG_EAP_GPSK=y
    CONFIG_EAP_GPSK_SHA256=y
    CONFIG_EAP_FAST=y
    CONFIG_EAP_IKEV2=y
    CONFIG_EAP_TNC=y
    CONFIG_EAP_EKE=y
    CONFIG_RADIUS_SERVER=y
    CONFIG_IEEE80211R=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211AC=y
    CONFIG_FULL_DYNAMIC_VLAN=y
    CONFIG_VLAN_NETLINK=y
    CONFIG_TLS=openssl
    CONFIG_TLSV11=y
    CONFIG_TLSV12=y
    CONFIG_INTERNETWORKING=y
    CONFIG_HS20=y
    CONFIG_ACS=y
    CONFIG_GETRANDOM=y
    CONFIG_SAE=y
  '';

  postPatch = ''
    substituteInPlace hostapd/Makefile --replace /usr/local $out
  '';

  configurePhase = ''
    runHook preConfigure
    cd hostapd
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libnl-${lib.versions.major libnl.version}.0)"
    runHook postConfigure
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/sensepost/hostapd-mana";
    description = "Featureful rogue wifi access point tool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bbjubjub ];
    platforms = platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "olsrd";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "OLSR";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xk355dm5pfjil1j4m724vkdnc178lv6hi6s1g0xgpd59avbx90j";
  };

  patches = [
    # remove if there's ever an upstream release that incorporates
    # https://github.com/OLSR/olsrd/pull/87
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt-routing/packages/b3897386771890ba1b15f672c2fed58630beedef/olsrd/patches/011-bison.patch";
      sha256 = "04cl4b8dpr1yjs7wa94jcszmkdzpnrn719a5m9nhm7lvfrn1rzd0";
    })
  ];

  buildInputs = [
    bison
    flex
  ];

  preConfigure = ''
    makeFlags="prefix=$out ETCDIR=$out/etc"
  '';

  meta = {
    description = "Adhoc wireless mesh routing daemon";
    license = lib.licenses.bsd3;
    homepage = "http://olsr.org/";
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}

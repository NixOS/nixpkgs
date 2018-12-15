{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0i4gf3qi16fg7dxq2l4vhkwh4f5lx7xd1ilpzcw26vccqkv3hvyl";
  };
}

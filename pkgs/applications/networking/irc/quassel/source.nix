{ fetchurl, fetchpatch }:

rec {
  version = "0.12.4";
  src = fetchurl {
    url = "https://github.com/quassel/quassel/archive/${version}.tar.gz";
    sha256 = "0q2qlhy1d6glw9pwxgcgwvspd1mkk3yi6m21dx9gnj86bxas2qs2";
  };
  patches = [
    (fetchpatch {
      name = "CVE-XXX-RCE.patch";
      url = "https://quassel-irc.org/pub/misc/0001-Implement-custom-deserializer-to-add-our-own-sanity-.patch";
      sha256 = "0w7gx0xhqfb2h1rxlh9q96bdd23szbxdjs3ydmrzzvyxj5sk8dzd";
    })
    (fetchpatch {
      name = "CVE-XXX-DOS.patch";
      url = "https://quassel-irc.org/pub/misc/0002-Reject-clients-that-attempt-to-login-before-the-core.patch";
      sha256 = "0is2jf7qppsx2y10f0zazm27lnkam83wpm8wmnfmdxdxj656ifd1";
    })
  ];
}

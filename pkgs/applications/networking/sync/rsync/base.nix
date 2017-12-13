{ stdenv, fetchurl, fetchpatch }:

rec {
  version = "3.1.2";
  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "1hm1q04hz15509f0p9bflw4d6jzfvpm1d36dxjwihk1wzakn5ypc";
  };
  patches = [
    (fetchurl {
      # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
      url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
      sha256 = "09i3dcl37p22dp75vlnsvx7bm05ggafnrf1zwhf2kbij4ngvxvpd";
    })
    (fetchpatch {
      name = "CVE-2017-16548.patch";
      url = "https://git.samba.org/rsync.git/?p=rsync.git;a=commitdiff_plain;h=47a63d90e71d3e19e0e96052bb8c6b9cb140ecc1;hp=bc112b0e7feece62ce98708092306639a8a53cce";
      sha256 = "1dcdnfhbc5gd0ph7pds0xr2v8rpb2a4p7l9c1wml96nhnyww1pg1";
    })
  ];

  meta = with stdenv.lib; {
    homepage = http://rsync.samba.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

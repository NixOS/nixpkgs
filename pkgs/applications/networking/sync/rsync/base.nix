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
    (fetchpatch {
      name = "CVE-2017-17433.patch";
      url = "https://git.samba.org/?p=rsync.git;a=patch;h=3e06d40029cfdce9d0f73d87cfd4edaf54be9c51";
      sha256 = "1kvnh6znp37a447h9fm2pk7v4phx20bk60j4wbsd92xlpp7vck52";
    })
    (fetchpatch {
      name = "CVE-2017-17434-patch1.patch";
      url = "https://git.samba.org/?p=rsync.git;a=patch;h=5509597decdbd7b91994210f700329d8a35e70a1";
      sha256 = "16gg670s6b4gn3fywkkagixkpkpf31a3fiqx2a544640pblbgvyx";
    })
    (fetchpatch {
      name = "CVE-2017-17434-patch2.patch";
      url = "https://git.samba.org/?p=rsync.git;a=patch;h=70aeb5fddd1b2f8e143276f8d5a085db16c593b9";
      sha256 = "182pc5bk1i57ganyn51bcs6vi2fib7zcw4kz3iyqkzihnjds10a6";
    })
  ];

  meta = with stdenv.lib; {
    homepage = http://rsync.samba.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

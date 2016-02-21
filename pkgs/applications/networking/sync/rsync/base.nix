{ stdenv, fetchurl }:

rec {
  version = "3.2.1";
  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "1hm1q04hz15509f0p9bflw4d6jzfvpm1d36dxjwihk1wzakn5ypc";
  };
  patches = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "09i3dcl37p22dp75vlnsvx7bm05ggafnrf1zwhf2kbij4ngvxvpd";
  };

  meta = with stdenv.lib; {
    homepage = http://rsync.samba.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

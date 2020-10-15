{ stdenv, fetchurl }:

rec {
  version = "3.2.3";
  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "03p5dha9g9krq61mdbcrjkpz5nglri0009ks2vs9k97f9i83rk5y";
  };
  upstreamPatchTarball = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "1wj21v57v135n6fnmlm2dxmb9lhrrg62jgkggldp1gb7d6s4arny";
  };

  meta = with stdenv.lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

{ stdenv, fetchurl, fetchpatch }:

rec {
  version = "3.1.3";
  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "1h0011dj6jgqpgribir4anljjv7bbrdcs8g91pbsmzf5zr75bk2m";
  };
  upstreamPatchTarball = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "167vk463bb3xl9c4gsbxms111dk1ip7pq8y361xc0xfa427q9hhd";
  };

  meta = with stdenv.lib; {
    description = "Fast incremental file transfer utility";
    homepage = https://rsync.samba.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, libarchive, xz, bzip2, zlib, lz4, lzo, openssl }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.libarchive";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "1q62p1i6rvqk2zv6f1cpffkh95lgclys2xl4dwyhj3acmqdxd9i5";
  };

  extraBuildInputs = [ libarchive xz bzip2 zlib lz4 lzo openssl ];

  meta = with lib; {
    description = "LibArchive Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}

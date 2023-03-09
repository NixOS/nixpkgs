{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, libarchive, xz, bzip2, zlib, lz4, lzo, openssl }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.libarchive";
  version = "19.0.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-4sERFC/XBEE46n+iq6YJg/5Wz0+223tq4+O5cIf6X6E=";
  };

  extraBuildInputs = [ libarchive xz bzip2 zlib lz4 lzo openssl ];

  meta = with lib; {
    description = "LibArchive Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}

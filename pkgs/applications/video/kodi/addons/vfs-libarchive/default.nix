{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libarchive,
  xz,
  bzip2,
  zlib,
  lz4,
  lzo,
  openssl,
}:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.libarchive";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-D0eLH+G+qF5xLBBX/FdJC+gKNQpqSb7LjRmi/99rPNg=";
  };

  extraBuildInputs = [
    libarchive
    xz
    bzip2
    zlib
    lz4
    lzo
    openssl
  ];

  meta = with lib; {
    description = "LibArchive Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}

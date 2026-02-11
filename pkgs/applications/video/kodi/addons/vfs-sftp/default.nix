{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  openssl,
  libssh,
  zlib,
}:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.sftp";
  version = "21.0.2";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-aD0AEr406urgnGVfB6C9JGaNmZAFL7WghnTZhbMfzA8=";
  };

  extraBuildInputs = [
    openssl
    libssh
    zlib
  ];

  meta = {
    description = "SFTP Virtual Filesystem add-on for Kodi";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    teams = [ lib.teams.kodi ];
  };
}

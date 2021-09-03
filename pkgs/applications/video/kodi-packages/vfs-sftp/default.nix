{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, libssh, zlib }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.sftp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "06w74sh8yagrrp7a7rjaz3xrh1j3wdqald9c4b72c33gpk5997dk";
  };

  extraBuildInputs = [ openssl libssh zlib ];

  meta = with lib; {
    description = "SFTP Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}

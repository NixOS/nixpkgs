{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, libssh, zlib }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.sftp";
  version = "20.1.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-Dv/C8PHaSx13JoGp77rQPtp5G5EH5tqKqzjwZZA7+80=";
  };

  extraBuildInputs = [ openssl libssh zlib ];

  meta = with lib; {
    description = "SFTP Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}

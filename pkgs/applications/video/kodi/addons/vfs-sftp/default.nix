{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, libssh, zlib }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "vfs.sftp";
  version = "19.0.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = namespace;
    rev = "${version}-${rel}";
    sha256 = "sha256-UXycPqPEn3W5X3SQs1fxgkdV5PSkzs3pjYyuhAVngt8=";
  };

  extraBuildInputs = [ openssl libssh zlib ];

  meta = with lib; {
    description = "SFTP Virtual Filesystem add-on for Kodi";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}

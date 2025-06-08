{
  lib,
  stdenv,
  fetchurl,
  check,
  libiconv,
  libshout,
  taglib,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ezstream";
  version = "1.0.2";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/xiph/releases/ezstream/${pname}-${version}.tar.gz";
    hash = "sha256-Ed6Jf0ValbpYVGvc1AqV072mmGbsX3h5qDsCQSbFTCo=";
  };

  checkInputs = [
    check
  ];

  buildInputs = [
    libiconv
    libshout
    taglib
    libxml2
  ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;

  meta = with lib; {
    description = "Command line source client for Icecast media streaming servers";
    longDescription = ''
      Ezstream is a command line source client for Icecast media
      streaming servers. It began as the successor of the old "shout"
      utility, and has since gained a lot of useful features.

      In its basic mode of operation, it streams media files or data
      from standard input without reencoding and thus requires only
      very little CPU resources.
    '';
    homepage = "https://icecast.org/ezstream/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.barrucadu ];
    platforms = platforms.all;
  };
}

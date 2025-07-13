{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "fcrackzip";
  version = "1.0";
  src = fetchurl {
    url = "https://oldhome.schmorp.de/marc/data/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  CFLAGS = "-std=gnu89";

  # 'fcrackzip --use-unzip' cannot deal with file names containing a single quote
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=430387
  patches = [ ./fcrackzip_forkexec.patch ];

  # Do not clash with unizp/zipinfo
  postInstall = "mv $out/bin/zipinfo $out/bin/fcrackzip-zipinfo";

  meta = with lib; {
    description = "zip password cracker, similar to fzc, zipcrack and others";
    homepage = "http://oldhome.schmorp.de/marc/fcrackzip.html";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nico202 ];
    platforms = with platforms; unix;
  };
}

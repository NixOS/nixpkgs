{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcrackzip";
  version = "1.0";
  src = fetchurl {
    url = "http://oldhome.schmorp.de/marc/data/fcrackzip-${finalAttrs.version}.tar.gz";
    sha256 = "0l1qsk949vnz18k4vjf3ppq8p497966x4c7f2yx18x8pk35whn2a";
  };

  CFLAGS = "-std=gnu89";

  # 'fcrackzip --use-unzip' cannot deal with file names containing a single quote
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=430387
  patches = [ ./fcrackzip_forkexec.patch ];

  # Do not clash with unizp/zipinfo
  postInstall = "mv $out/bin/zipinfo $out/bin/fcrackzip-zipinfo";

  meta = {
    description = "Zip password cracker, similar to fzc, zipcrack and others";
    homepage = "http://oldhome.schmorp.de/marc/fcrackzip.html";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nico202 ];
    platforms = with lib.platforms; unix;
  };
})

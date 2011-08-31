{ fetchurl, stdenv }:

let
  name = "antiword-0.37";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.winfield.demon.nl/linux/${name}.tar.gz";
    sha256 = "1b7mi1l20jhj09kyh0bq14qzz8vdhhyf35gzwsq43mn6rc7h0b4f";
  };

  installFlags = "GLOBAL_INSTALL_DIR=$$out/bin GLOBAL_RESOURCES_DIR=$$out/share/antiword";
  installTargets = "global_install";

  meta = {
    homepage = "http://www.winfield.demon.nl/";
    description = "convert MS Word documents to plain text or PostScript";
    license = stdenv.lib.licenses.gpl2;

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjson";
  version = "7.6.1";
  src = fetchurl {
    url = "mirror://sourceforge/libjson/libjson_${finalAttrs.version}.zip";
    sha256 = "0xkk5qc7kjcdwz9l04kmiz1nhmi7iszl3k165phf53h3a4wpl9h7";
  };
  patches = [ ./install-fix.patch ];
  nativeBuildInputs = [ unzip ];
  makeFlags = [ "prefix=$(out)" ];
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++11" ];
  preInstall = "mkdir -p $out/lib";

  meta = {
    homepage = "http://libjson.sourceforge.net/";
    description = "JSON reader and writer";
    longDescription = ''
      A JSON reader and writer which is super-efficient and
      usually runs circles around other JSON libraries.
      It's highly customizable to optimize for your particular project, and
      very lightweight. For Windows, OSX, or Linux. Works in any language.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
})

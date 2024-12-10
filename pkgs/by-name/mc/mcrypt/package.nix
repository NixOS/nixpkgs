{
  lib,
  stdenv,
  fetchurl,
  libmcrypt,
  libmhash,
}:

stdenv.mkDerivation rec {
  version = "2.6.8";
  pname = "mcrypt";

  src = fetchurl {
    url = "mirror://sourceforge/mcrypt/MCrypt/${version}/mcrypt-${version}.tar.gz";
    sha256 = "5145aa844e54cca89ddab6fb7dd9e5952811d8d787c4f4bf27eb261e6c182098";
  };

  patches = [
    ./format-string_CVE-2012-4426.patch
    ./overflow_CVE-2012-4409.patch
    ./segv.patch
    ./sprintf_CVE-2012-4527.patch
    ./malloc_to_stdlib.patch
  ];

  buildInputs = [
    libmcrypt
    libmhash
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  meta = {
    description = "Replacement for old UNIX crypt(1)";
    longDescription = ''
      mcrypt, and the accompanying libmcrypt, are intended to be replacements
      for the old Unix crypt, except that they are under the GPL and support an
      ever-wider range of algorithms and modes.
    '';
    homepage = "https://mcrypt.sourceforge.net";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.qknight ];
  };
}

{
  lib,
  stdenv,
  fetchurl,
  libmcrypt,
  libmhash,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.6.8";
  pname = "mcrypt";

  src = fetchurl {
    url = "mirror://sourceforge/mcrypt/MCrypt/${finalAttrs.version}/mcrypt-${finalAttrs.version}.tar.gz";
    hash = "sha256-UUWqhE5UzKid2rb7fdnllSgR2NeHxPS/J+smHmwYIJg=";
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

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  meta = {
    description = "Replacement for old UNIX crypt(1)";
    longDescription = ''
      mcrypt, and the accompanying libmcrypt, are intended to be replacements
      for the old Unix crypt, except that they are under the GPL and support an
      ever-wider range of algorithms and modes.
    '';
    homepage = "https://mcrypt.sourceforge.net";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.qknight ];
  };
})

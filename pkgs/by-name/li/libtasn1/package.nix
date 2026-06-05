{
  lib,
  stdenv,
  fetchurl,
  perl,
  texinfo,

  # for passthru.tests
  gnutls,
  samba,
  qemu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtasn1";
  version = "4.21.0";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/libtasn1-${finalAttrs.version}.tar.gz";
    hash = "sha256-HYpESiI8xUZCQHdzRuEl3lHY5qvwuLrHQqyEYJFn3Ic=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  nativeBuildInputs = [
    texinfo
    perl
  ];

  doCheck = true;
  preCheck =
    if stdenv.hostPlatform.isDarwin then "export DYLD_LIBRARY_PATH=`pwd`/lib/.libs" else null;

  passthru.tests = {
    inherit gnutls samba qemu;
  };

  meta = {
    homepage = "https://www.gnu.org/software/libtasn1/";
    description = "ASN.1 library";
    longDescription = ''
      Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
      other packages.  The goal of this implementation is to be highly
      portable, and only require an ANSI C89 platform.
    '';
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
    changelog = "https://gitlab.com/gnutls/libtasn1/-/blob/v${finalAttrs.version}/NEWS.md";
  };
})

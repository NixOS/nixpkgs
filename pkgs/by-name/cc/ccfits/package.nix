{
  lib,
  stdenv,
  fetchurl,
  cfitsio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccfits";
  version = "2.7";

  src = fetchurl {
    url = "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/ccfits/v${finalAttrs.finalPackage.version}/CCfits-${finalAttrs.finalPackage.version}.tar.gz";
    hash = "sha256-9jVG0v7sv3MswIqqqAoutTNK2jf7JTAYG3NjpdvesBo=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ cfitsio ];

  # $out/bin/cookbook only needed for manual tests
  postInstall = ''
    rm -rf $out/bin/
  '';

  meta = {
    homepage = "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/ccfits/";
    description = "An object oriented interface to the cfitsio library";
    longDescription = ''
      CCfits is an object oriented interface to the cfitsio library. It is
      designed to make the capabilities of cfitsio available to programmers
      working in C++. It is written in ANSI C++ and implemented using the C++
      Standard Library with namespaces, exception handling, and member
      template functions.
    '';
    license = lib.licenses.cfitsio;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ panicgh ];
  };
})

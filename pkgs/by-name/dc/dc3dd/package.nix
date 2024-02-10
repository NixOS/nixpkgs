{ lib
, stdenv
, fetchzip
, perlPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dc3dd";
  version = "7.3.1";

  src = fetchzip {
    url = "mirror://sourceforge/dc3dd/dc3dd-${finalAttrs.version}.zip";
    hash = "sha256-SYDoqGlsROHX1a0jJX11F+yp6CeFK+tZbYOOnScC6Ig=";
  };

  outputs = [ "out" "man" ];

  preConfigure = ''
    chmod +x configure
  '';

  buildInputs = [ perlPackages.LocaleGettext ];

  makeFlags = [
    "PREFIX=$out"
  ];

  configureFlags = lib.optionals (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) [ "--build=arm" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A patched version of dd that includes a number of features useful for computer forensics";
    mainProgram = "dc3dd";
    homepage = "https://sourceforge.net/projects/dc3dd/";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus; # Refer to https://sourceforge.net/p/dc3dd/code/HEAD/tree/COPYING
    broken = stdenv.isDarwin;
  };
})

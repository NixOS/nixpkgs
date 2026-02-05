{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "std-man-pages";
  version = "4.4.0";

  src = fetchurl {
    url = "mirror://gcc/libstdc++/doxygen/libstdc++-man.${finalAttrs.version}.tar.bz2";
    sha256 = "0153py77ll759jacq41dp2z2ksr08pdcfic0rwjd6pr84dk89y9v";
  };

  outputDevdoc = "out";

  installPhase = ''
    mkdir -p $out/share/man
    cp -R * $out/share/man
  '';

  meta = {
    description = "GCC C++ STD manual pages";
    homepage = "https://gcc.gnu.org/";
    license = with lib.licenses; [ fdl13Plus ];
    platforms = lib.platforms.unix;
  };
})

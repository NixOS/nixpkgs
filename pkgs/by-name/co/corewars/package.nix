{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
}:

let
  gtk2-support-patch = fetchurl {
    url = "https://sourceforge.net/p/corewars/patches/_discuss/thread/947a192c/b4cd/attachment/corewars-gtk2.patch.gz";
    hash = "sha256-nSaXUjRO+ckT5X8EycXUf3iMWFdV2+MFCrq1DQVzizA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "corewars";
  version = "0.9.13";

  src = fetchurl {
    url = "mirror://sourceforge/corewars/corewars-${finalAttrs.version}.tar.gz";
    hash = "sha256-I5V+Yg47vuJlw+uHh1LK9dQYZCjjYa95ozc6aYAQ9uI=";
  };

  postPatch = ''
    zcat ${gtk2-support-patch} | patch -Np1
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk2 ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-fcommon" # for GCC 10 and above
    "-lm" # fix: error adding symbols: DSO missing from command line
    "-Wno-deprecated-declarations"
  ];

  meta = {
    description = "A simulation game where programs try to crash each other";
    homepage = "http://corewars.org";
    license = lib.licenses.gpl2Only;
    mainProgram = "corewars";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "direvent";
  version = "5.5";

  src = fetchurl {
    url = "mirror://gnu/direvent/direvent-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-DhbAtLPm92c+m08x2BqwEjatIvg1OFEvOy9Y+flv3Lc=";
  };

  patches = [
    ./fix-darwin.patch
    ./use-nonosleep-if-clock-nanosleep-not-available.patch
  ];

  nativeBuildInputs = [
    # The nanosleep patch about modifies configure.ac so we use autoreconfHook.
    # We should be able to remove this when we drop the nanosleep patch.
    autoreconfHook
  ];

  meta = {
    description = "Directory event monitoring daemon";
    mainProgram = "direvent";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ puffnfresh ];
  };
})

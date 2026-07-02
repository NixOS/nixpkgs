{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libmatchbox,
  libx11,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matchbox";
  version = "1.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmatchbox ];
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-L${libx11}/lib"
    "-lXext"
    "-L${libxext}/lib"
  ];

  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/matchbox/matchbox-window-manager/${finalAttrs.version}/matchbox-window-manager-${finalAttrs.version}.tar.bz2";
    sha256 = "1zyfq438b466ygcz78nvsmnsc5bhg4wcfnpxb43kbkwpyx53m8l1";
  };

  patches = [
    # Pull upstream fix for -fno-common tollchains:
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://git.yoctoproject.org/matchbox-window-manager/patch/?id=844f61069896fe3f549ab425d731c061028f697c";
      sha256 = "1md2s7q094hn4gzg21pfyz8d426y07d5rbx2icas9nvc8jj7bwfc";
    })
  ];

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = "https://www.yoctoproject.org/software-item/matchbox/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})

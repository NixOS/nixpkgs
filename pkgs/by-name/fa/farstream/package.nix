{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  buildPackages,
  libnice,
  pkg-config,
  gst_all_1,
  gupnp-igd,
  gobject-introspection,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "farstream";
  version = "0.2.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/farstream/releases/farstream/farstream-${finalAttrs.version}.tar.gz";
    sha256 = "0yzlh9jf47a3ir40447s7hlwp98f9yr8z4gcm0vjwz6g6cj12zfb";
  };

  patches = [
    # Fix build with newer gnumake.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/farstream/farstream/-/commit/54987d44.diff";
      sha256 = "02pka68p2j1wg7768rq7afa5wl9xv82wp86q7izrmwwnxdmz4zyg";
    })
  ];

  buildInputs = [
    libnice
    gupnp-igd
    libnice
  ];

  nativeBuildInputs = [
    pkg-config
    buildPackages.autoreconfHook269
    gobject-introspection
    python3
  ];

  propagatedBuildInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ];

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/Farstream";
    description = "Audio/Video Communications Framework formely known as farsight";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
  };
})

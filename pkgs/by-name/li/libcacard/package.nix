{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  nss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcacard";
  version = "2.8.2";

  src = fetchurl {
    url = "https://www.spice-space.org/download/libcacard/libcacard-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-Rfwopv88ejWdREgTLKGQ8KnHYFQMRF26RZeltx3kD2g=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '/--version-script/d' Makefile.in
    sed -i 's/^vflag = .*$/vflag = ""/' meson.build
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    nss
  ];

  meta = {
    description = "Smart card emulation library";
    homepage = "https://gitlab.freedesktop.org/spice/libcacard";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

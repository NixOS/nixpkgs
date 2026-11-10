{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libdmx";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libdmx-${finalAttrs.version}.tar.xz";
    hash = "sha256-NaTiaosLK0/jZEHcpGNkXD+lLSgqw1IFAaOOqULL908=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  passthru = {
    # updateScript = # libdmx it deprecated and thus needs no updatescript
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Xlib-based library for the DMX (Distributed Multihead X) extension";
    longDescription = ''
      This library allows X11 clients to use the Distributed Multihead X (DMX) Extension,
      as previously implemented in the Xdmx server.
      X.Org removed support for the Xdmx server from the xorg-server releases in the version 21
      release in 2021. This library is thus now considered deprecated and the version 1.1.5 release
      is the last release X.Org plans to make of libdmx.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libdmx";
    license = lib.licenses.mit;
    maintainers = [ ];
    pkgConfigModules = [ "dmx" ];
    platforms = lib.platforms.unix;
  };
})

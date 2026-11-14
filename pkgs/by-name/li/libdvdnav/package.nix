{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libdvdread,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdnav";
  version = "6.1.1";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;
  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://get.videolan.org/libdvdnav/${finalAttrs.version}/libdvdnav-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-wZGnR1lH0yP/doDPksD7G+gjdwGIXzdlbGTQTpjRjUg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libdvdread ];

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library that implements DVD navigation features such as DVD menus";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "dvdnav"
    ];
  };

  passthru = {
    inherit libdvdread;
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
    };
  };
})

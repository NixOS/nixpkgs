{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libdvdcss,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdread";
  version = "7.1.1";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;
  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://get.videolan.org/libdvdread/${finalAttrs.version}/libdvdread-${finalAttrs.version}.tar.xz";
    hash = "sha256-oNR4dlSL7IBndLv42/ILsZuhOUZDgxVrMuuOWZFbkKk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ libdvdcss ];

  mesonFlags = [
    (lib.mesonEnable "libdvdcss" true)
  ];

  postInstall = ''
    ln -s dvdread $dev/include/libdvdread
  '';

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
    };
  };

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library for reading DVDs";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "dvdread"
    ];
  };
})

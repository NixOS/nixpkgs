{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  ninja,
  testers,

  # for passthru.tests
  audacity,
  mpd,
  normalize,
  ocamlPackages,
  streamripper,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmad";
  version = "0.16.5";

  src = fetchFromCodeberg {
    owner = "tenacityteam";
    repo = "libmad";
    tag = finalAttrs.version;
    hash = "sha256-zfjfP5xiijRTVaYauVTY6Pwsq4XhjYMpHZ/aH0e5Tds=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [ (lib.cmakeBool "EXAMPLE" false) ];

  passthru.tests = {
    inherit
      audacity
      mpd
      normalize
      streamripper
      vlc
      ;
    ocaml-mad = ocamlPackages.mad;
    pkg-cconfig = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://codeberg.org/tenacityteam/libmad";
    description = "High-quality, fixed-point MPEG audio decoder supporting MPEG-1 and MPEG-2";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    pkgConfigModules = [ "mad" ];
    platforms = lib.platforms.unix;
  };
})

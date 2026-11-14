{
  lib,
  stdenv,
  testers,
  fetchFromGitLab,
  gitUpdater,

  pkg-config,
  meson,
  ninja,
  libdvdread,

  # for passthru.tests
  gst_all_1,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdnav";
  version = "7.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "libdvdnav";
    tag = finalAttrs.version;
    hash = "sha256-WuHgMsCEdIRJxvueixFQLMV4Q0gwh7p/KNKzHZZpLDM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [ libdvdread ];

  passthru = {
    inherit libdvdread;

    updateScript = gitUpdater { };

    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      inherit (gst_all_1) gst-plugins-bad;
    };
  };

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library that implements DVD navigation features such as DVD menus";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "dvdnav" ];
  };
})

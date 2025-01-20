{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  testers,
  glib,
  libsForQt5,
  pkg-config,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sailfish-access-control";
  version = "0.0.11";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "sailfish-access-control";
    tag = finalAttrs.version;
    hash = "sha256-RO+fHyN0yZlKIQVNrbWuVVr1jolchc4RW+J4JAC5ygs=";
  };

  patches = [
    # Remove when https://github.com/sailfishos/sailfish-access-control/pull/6 merged & in release
    (fetchpatch {
      name = "0001-sailfish-access-control-Add-missing-limits-includes.patch";
      url = "https://github.com/sailfishos/sailfish-access-control/commit/1d4f31c71c512a8dbb1f9f50f125cdf3b274a27c.patch";
      hash = "sha256-Tuw5GJW2RcqkOXVIilm0eWiOIR2uCqM6NdFbT/5PGvo=";
    })
  ];

  # sourceRoot breaks patches
  preConfigure = ''
    cd glib
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
  ];

  installFlags = [
    "ROOT="
    "PREFIX=${placeholder "out"}"
    "INCDIR=${placeholder "dev"}/include/sailfishaccesscontrol"
  ];

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
      qt5 = libsForQt5.sailfish-access-control-plugin;
      qt6 = qt6Packages.sailfish-access-control-plugin;
    };
  };

  meta = {
    description = "Thin wrapper on top of pwd.h and grp.h of glibc";
    longDescription = ''
      This package provides a thin wrapper library on top of the getuid, getpwuid, getgrouplist, and friends.
      Checking whether a user belongs to a group should be done via this Sailfish Access Control library.

      This will make it easier to fix for instance rerentrancy issues.
    '';
    homepage = "https://github.com/sailfishos/sailfish-access-control";
    changelog = "https://github.com/sailfishos/sailfish-access-control/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "sailfishaccesscontrol"
    ];
  };
})

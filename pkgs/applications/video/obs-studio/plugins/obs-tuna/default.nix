{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, obs-studio
, cmake
, zlib
, curl
, taglib
, dbus
, pkg-config
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-tuna";
  version = "1.9.7";

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ obs-studio qtbase zlib curl taglib dbus ];

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "tuna";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NpfQ3zi+1kQNt2Lj4+1kX2bW9A/E2/MhUV1BA1UX4y0=";
    fetchSubmodules = true;
  };

  # obs_frontend_add_dock() deprecated in obs 30
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  patches = [
    # fix build with qt 6.6.0
    # treewide: replace deprecated qAsConst with std::as_const()
    # https://github.com/univrsal/tuna/pull/176
    (fetchpatch2 {
      url = "https://github.com/univrsal/tuna/commit/0d570e771f8d8e6ae7c85bd2b86bbf59c264789e.patch";
      hash = "sha256-A5idhMiM9funqhTm5XMIBqwy+FO1SaNPtgZjo+Vws6k=";
    })
    # fix build with obs 30
    (fetchpatch2 {
      url = "https://github.com/univrsal/tuna/commit/723bd3c7b4e257cf0997611426e555068de77ae7.patch";
      hash = "sha256-MF5vghGYknL6q+A8BJ1yrQcEKIu9I+PWk+RZNYg3fRU=";
    })
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Song information plugin for obs-studio";
    homepage = "https://github.com/univrsal/tuna";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ shortcord ];
    platforms = lib.platforms.linux;
  };
})

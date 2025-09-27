{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  intltool,
  autoreconfHook,
  gtk3,
  glib,
  curl,
  goocanvas2,
  gpsd,
  hamlib_4,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpredict";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "csete";
    repo = "gpredict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+hgjImfT3nWMBYwde7+KC/hzd84pwQbpoJvaJSNG4E8=";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains:
    #   https://github.com/csete/gpredict/issues/195
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/csete/gpredict/commit/c565bb3d48777bfe17114b5d01cd81150521f056.patch";
      sha256 = "1jhy9hpqlachq32bkij60q3dxkgi1kkr80rm29jjxqpmambf406a";
    })
    # Updates URLs for TLE files
    # https://github.com/csete/gpredict/pull/305
    (fetchpatch {
      name = "TLE-urls.patch";
      url = "https://github.com/csete/gpredict/commit/8f60f856921e8ee143cd6e2d34a9183778cb0fbf.patch";
      hash = "sha256-X/nKrqh5sjxDMLhA9LQek8AsJFqhvK/k8Ep3ug/0rMI=";
    })

  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
    autoreconfHook
  ];
  buildInputs = [
    curl
    glib
    gtk3
    goocanvas2
    gpsd
    hamlib_4
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real time satellite tracking and orbit prediction";
    mainProgram = "gpredict";
    longDescription = ''
      Gpredict is a real time satellite tracking and orbit prediction program
      written using the GTK widgets. Gpredict is targetted mainly towards ham radio
      operators but others interested in satellite tracking may find it useful as
      well. Gpredict uses the SGP4/SDP4 algorithms, which are compatible with the
      NORAD Keplerian elements.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    homepage = "http://gpredict.oz9aec.net/";
    maintainers = with lib.maintainers; [
      markuskowa
      cmcdragonkai
      pandapip1
    ];
  };
})

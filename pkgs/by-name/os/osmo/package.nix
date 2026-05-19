{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
  pkg-config,
  gtk3,
  libxml2,
  gettext,
  libical,
  libnotify,
  libarchive,
  gspell,
  webkitgtk_4_1,
  libgringotts,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo";
  version = "0.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/osmo-pim/osmo-${finalAttrs.version}.tar.gz";
    sha256 = "19h3dnjgqbawnvgnycyp4n5b6mjsp5zghn3b69b6f3xa3fyi32qy";
  };

  patches = [
    (fetchDebianPatch {
      pname = "osmo";
      version = "0.4.4";
      debianRevision = "3";
      patch = "gcc-15.patch";
      hash = "sha256-2T34wYczOTc57tjt3w91q8TDtQZqLpwYOsr8JKpYs0c=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    libxml2
    libical
    libnotify
    libarchive
    gspell
    webkitgtk_4_1
    libgringotts
  ];

  meta = {
    description = "Handy personal organizer";
    mainProgram = "osmo";
    homepage = "https://clayo.org/osmo/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})

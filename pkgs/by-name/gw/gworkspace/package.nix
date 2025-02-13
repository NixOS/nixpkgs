{
  lib,
  clangStdenv,
  fetchurl,
  gnustep-back,
  gnustep-systempreferences,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gworkspace";
  version = "1.0.0";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-M7dV7RVatw8gdYHQlRi5wNBd6MGT9GqW04R/DoKNu6I=";
  };

  # additional dependencies:
  # - PDFKit framework from http://gap.nongnu.org/
  # - TODO: to --enable-gwmetadata, need libDBKit as well as sqlite!
  nativeBuildInputs = [ wrapGNUstepAppsHook ];

  buildInputs = [
    gnustep-back
    gnustep-systempreferences
  ];

  configureFlags = [ "--with-inotify" ];

  meta = {
    description = "Workspace manager for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "GWorkspace";
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
    platforms = lib.platforms.linux;
  };
})

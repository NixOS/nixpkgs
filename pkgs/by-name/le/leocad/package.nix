{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  povray,
  libsForQt5,
  replaceVars,
  zlib,
  testers,
  nix-update-script,
  libGL,
}:

/*
  To use additional parts libraries
  set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

let
  parts = fetchurl {
    url = "https://web.archive.org/web/20241230062818/https://library.ldraw.org/library/updates/complete.zip";
    hash = "sha256-0RIJYEU+MpE4MSfxk2HK5hQd8IsiPn2xEGUFmItzlk8=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "leocad";
  version = "23.03";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IY9mr2gSMZL9pxiVTKH/f7rjsOvBDNgwVKpXA57oMGo=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libGL
  ];

  propagatedBuildInputs = [ povray ];

  patches = [
    (replaceVars ./povray.patch {
      inherit povray;
    })
  ];

  qmakeFlags = [
    "INSTALL_PREFIX=${placeholder "out"}"
    "DISABLE_UPDATE_CHECK=1"
  ];

  qtWrapperArgs = [
    "--set-default LEOCAD_LIB ${parts}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "env QT_QPA_PLATFORM=minimal ${lib.getExe finalAttrs.finalPackage} --version";
    };
    updateScript = nix-update-script { };
  };

  passthru = {
    description = "CAD program for creating virtual LEGO models";
    mainProgram = "leocad";
    homepage = "https://www.leocad.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    platforms = lib.platforms.linux;
  };
})

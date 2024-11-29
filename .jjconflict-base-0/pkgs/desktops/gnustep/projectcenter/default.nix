{ lib
, stdenv
, fetchFromGitHub
, make
, wrapGNUstepAppsHook
, base
, back
, gui
, gorm
, gnumake
, gdb
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projectcenter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "apps-projectcenter";
    rev = "projectcenter-${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-uXT2UUvMZNc6Fqi2BUXQimbZk8b3IqXzB+A2btBOmms=";
  };

  nativeBuildInputs = [ make wrapGNUstepAppsHook ];

  # NOTE: need a patch for ProjectCenter to help it locate some necessary tools:
  # 1. Framework/PCProjectLauncher.m, locate gdb (say among NIX_GNUSTEP_SYSTEM_TOOLS)
  # 2. Framework/PCProjectBuilder.m, locate gmake (similar)
  propagatedBuildInputs = [ base back gui gnumake gdb gorm ];

  meta = {
    description = "GNUstep's integrated development environment";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "ProjectCenter";
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})

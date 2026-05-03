{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgdsii";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "HomerReid";
    repo = "libGDSII";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EXEt7l69etcBdDdEDlD1ODOdhTBZCVjgY1jhRUDd/W0=";
  };

  # File is missing in the repo but automake requires it
  postPatch = ''
    touch ChangeLog
  '';

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Library and command-line utility for reading GDSII geometry files";
    mainProgram = "GDSIIConvert";
    homepage = "https://github.com/HomerReid/libGDSII";
    license = [ lib.licenses.gpl2Only ];
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
    platforms = lib.platforms.linux;
  };
})

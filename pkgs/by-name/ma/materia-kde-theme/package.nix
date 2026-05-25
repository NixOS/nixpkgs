{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "materia-kde-theme";
  version = "20220823";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "materia-kde";
    rev = finalAttrs.version;
    sha256 = "sha256-/O+/L6C9WjxhfWZ8RzIeimNU+8sjKvbDvQwNlvVOjU4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.diffumist ];
    platforms = lib.platforms.all;
  };
})

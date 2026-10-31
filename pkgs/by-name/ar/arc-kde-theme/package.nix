{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arc-kde-theme";
  version = "20220908";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "arc-kde";
    tag = finalAttrs.version;
    sha256 = "sha256-dxk8YpJB4XaZHD/O+WvQUFKJD2TE38VZyC5orn4N7BA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Port of the arc theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/arc-kde";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nixy ];
    platforms = lib.platforms.all;
  };
})

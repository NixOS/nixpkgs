{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "shabnam-fonts";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "shabnam-font";
    rev = "v${version}";
    hash = "sha256-H03GTKRVPiwU4edkr4x5upW4JCy6320Lo+cKK9FRMQs=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/rastikerdar/shabnam-font";
    description = "Persian (Farsi) Font - فونت (قلم) فارسی شبنم";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}

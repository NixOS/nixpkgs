{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bgpq3";
  version = "0.1.38";

  src = fetchFromGitHub {
    owner = "snar";
    repo = "bgpq3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rqZI7yqlVHfdRTOsA5V6kzJ2TGCy8mp6yP+rzsQX9Yc=";
  };

  meta = {
    description = "bgp filtering automation tool";
    homepage = "https://github.com/snar/bgpq3";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ b4dm4n ];
    platforms = with lib.platforms; unix;
    mainProgram = "bgpq3";
  };
})

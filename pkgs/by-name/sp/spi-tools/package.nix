{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spi-tools";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cpb-";
    repo = "spi-tools";
    tag = finalAttrs.version;
    hash = "sha256-lrdoO4ZsZCf0pt1SSL5w4rXVuYzlkJZQpditYt61nUw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Simple command line tools to help using Linux spidev devices";
    homepage = "https://github.com/cpb-/spi-tools";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ maxmosk ];
  };
})

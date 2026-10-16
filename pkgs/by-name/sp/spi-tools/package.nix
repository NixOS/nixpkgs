{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spi-tools";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "cpb-";
    repo = "spi-tools";
    tag = finalAttrs.version;
    hash = "sha256-mlOpgzJ8YFX+2y8+V3A2WjsnOzzj+fF8lJHqzoEP30s=";
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

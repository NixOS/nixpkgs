{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libytnef";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kQb45Da0T7wWi1IivA8Whk+ECL2nyFf7Gc0gK1HKj2c=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})

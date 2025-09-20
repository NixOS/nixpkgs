{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libytnef";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${version}";
    hash = "sha256-kQb45Da0T7wWi1IivA8Whk+ECL2nyFf7Gc0gK1HKj2c=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    inherit (src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}

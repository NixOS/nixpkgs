{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libast";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "mej";
    repo = pname;
    rev = version;
    hash = "sha256-rnqToFi+d6D6O+JDHQxkVjTc/0RBag6Jqv4uDcE4PNc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    inherit (src.meta) homepage;
    description = "Library of Assorted Spiffy Things";
    mainProgram = "libast-config";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}

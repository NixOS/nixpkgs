{ stdenv,
  lib,
  fetchFromGitHub,
  readline,
  autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "microcom";
<<<<<<< HEAD
  version = "2023.09.0";
=======
  version = "2019.01.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pengutronix";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CT/myxOK4U3DzliGsa45WMIFcYLjcoxx6w5S1NL5c7Y=";
=======
    sha256 = "056v28hvagnzns6p8i3bq8609k82d3w1ab2lab5dr4cdfwhs4pqj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ readline ];

  meta = with lib; {
    description = "A minimalistic terminal program for communicating
    with devices over a serial connection";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}

{ stdenv,
  lib,
  fetchFromGitHub,
  readline,
  autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "microcom";
  version = "2023.09.0";

  src = fetchFromGitHub {
    owner = "pengutronix";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CT/myxOK4U3DzliGsa45WMIFcYLjcoxx6w5S1NL5c7Y=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ readline ];

  meta = with lib; {
    description = "Minimalistic terminal program for communicating
    with devices over a serial connection";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
    mainProgram = "microcom";
  };
}

{ stdenv,
  lib,
  fetchFromGitHub,
  readline,
  autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "microcom";
  version = "2019.01.0";

  src = fetchFromGitHub {
    owner = "pengutronix";
    repo = pname;
    rev = "v${version}";
    sha256 = "056v28hvagnzns6p8i3bq8609k82d3w1ab2lab5dr4cdfwhs4pqj";
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

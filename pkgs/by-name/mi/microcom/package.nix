{
  stdenv,
  lib,
  fetchFromGitHub,
  readline,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "microcom";
  version = "2025.11.0";

  src = fetchFromGitHub {
    owner = "pengutronix";
    repo = "microcom";
    rev = "v${version}";
    hash = "sha256-drQpUOl+QLBvwT++bEBk9Bt+tTQxrnFgfuoGIW5Bcyw=";
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

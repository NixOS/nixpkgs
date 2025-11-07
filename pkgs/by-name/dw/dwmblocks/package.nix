{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  patches ? [ ],
  writeText,
  conf ? null,
}:

stdenv.mkDerivation {
  pname = "dwmblocks";
  version = "0-unstable-2024-08-24";

  src = fetchFromGitHub {
    owner = "torrinfail";
    repo = "dwmblocks";
    rev = "8cedd220684064f1433749ed2a19a6184c22cf07";
    hash = "sha256-QtYQB2mvw1k2LA8D+/cVnA8+GRDWjhIM6rxfi/IGjEw=";
  };

  buildInputs = [ libX11 ];

  inherit patches;

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "blocks.def.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} blocks.def.h";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Modular status bar for dwm written in c";
    homepage = "https://github.com/torrinfail/dwmblocks";
    license = licenses.isc;
    maintainers = with maintainers; [ sophrosyne ];
    platforms = platforms.linux;
    mainProgram = "dwmblocks";
  };
}

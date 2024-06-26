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
  version = "unstable-2020-12-27";

  src = fetchFromGitHub {
    owner = "torrinfail";
    repo = "dwmblocks";
    rev = "96cbb453e5373c05372fd4bf3faacfa53e409067";
    sha256 = "00lxfxsrvhm60zzqlcwdv7xkqzya69mgpi2mr3ivzbc8s9h8nwqx";
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

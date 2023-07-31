{ lib, stdenv, fetchFromSourcehut, writeText, patches ? [ ], conf ? null }:
stdenv.mkDerivation rec {
  pname = "someblocks";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~raphi";
    repo = "someblocks";
    rev = version;
    sha256 = "sha256-pUdiEyhqLx3aMjN0D0y0ykeXF3qjJO0mM8j1gLIf+ww=";
  };

  inherit patches;
  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf
        then conf else writeText "blocks.def.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} blocks.def.h";

  dontConfigure = true;

  NIX_CFLAGS_COMPILE = [ "-Wno-unused-result" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Modular status bar for somebar, based on dwmblocks";
    homepage = "https://sr.ht/~raphi/someblocks";
    license = licenses.isc;
    maintainers = with maintainers; [ stonks3141 ];
    platforms = platforms.linux;
  };
}

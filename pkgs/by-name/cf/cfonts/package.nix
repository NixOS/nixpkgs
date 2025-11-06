{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rgdqQzJyb1/bYB3S1MD/53vdQ+GaxOvGHuPE6dxMRB0=";
  };

  cargoHash = "sha256-Gf4W7ACyyVSCXV2RmpAfrE7Xircjk34Llk2j58cWXtU=";

  meta = with lib; {
    homepage = "https://github.com/dominikwilkowski/cfonts";
    description = "Silly little command line tool for sexy ANSI fonts in the console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leifhelm ];
    mainProgram = "cfonts";
  };
}

{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "dwfv";
  version = "0.4.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0xxgwbbbzaldbl04k5ksk61wa6i4f9mc84q04ljg438z0k8q6cr7";
  };

  cargoHash = "sha256-nmnpHz9sCRlxOngcSrW+oktYIKM/A295/a03fUf3ofw=";

  meta = with lib; {
    description = "Simple digital waveform viewer with vi-like key bindings";
    mainProgram = "dwfv";
    homepage = "https://github.com/psurply/dwfv";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}

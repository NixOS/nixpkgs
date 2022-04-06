{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "toipe";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-/vO5ABMldw3soh7mscjhN5TAZOcs+iMTaMxcdMmV0Xo=";
  };

  cargoSha256 = "sha256-AsRQ8kvDy1cH4/kaFAoU7en3dzDiG1T+O+4r6PKa0hM=";

  meta = with lib; {
    description = "Trusty terminal typing tester";
    homepage = "https://github.com/Samyak2/toipe";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier samyak ];
  };
}

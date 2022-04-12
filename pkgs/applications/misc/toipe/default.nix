{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "toipe";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-lAvFCvNm55SjRmrhIkMBiM0nSlAG+jUEKLlLaGs1RkY=";
  };

  cargoSha256 = "sha256-WmWH/x69H17uHQEB0+GRUtApJnSEkoeFLLweP8NoBrk=";

  meta = with lib; {
    description = "Trusty terminal typing tester";
    homepage = "https://github.com/Samyak2/toipe";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier samyak ];
  };
}

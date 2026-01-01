{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pbgopy";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = "pbgopy";
    rev = "v${version}";
    sha256 = "sha256-P/MFDFMsqSTVErTM9izJJSMIbiOcbQ9Ya10/w6NRcYw=";
  };

  vendorHash = "sha256-S2X74My6wyDZOsEYTDilCFaYgV2vQzU0jOAY9cEkJ6A=";

<<<<<<< HEAD
  meta = {
    description = "Copy and paste between devices";
    mainProgram = "pbgopy";
    homepage = "https://github.com/nakabonne/pbgopy";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Copy and paste between devices";
    mainProgram = "pbgopy";
    homepage = "https://github.com/nakabonne/pbgopy";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}

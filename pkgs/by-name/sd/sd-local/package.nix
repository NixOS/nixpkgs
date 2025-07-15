{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.58";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = "sd-local";
    rev = "v${version}";
    sha256 = "sha256-7nL+9tJt4EnGGIhsGASXdBp0u7PXbbt50ADdK2Ciel0=";
  };

  vendorHash = "sha256-CcVb2ugvKzl/HTtub4iq81u7hps7Q5a1e1e+T5t13hY=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    mainProgram = "sd-local";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}

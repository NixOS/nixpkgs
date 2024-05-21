{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "regols";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "kitagry";
    repo = "regols";
    rev = "v${version}";
    hash = "sha256-nZ0zBCZXVY2AqzsBWm/HOp9wO7Cj1AsSgpi6YwmhfHY=";
  };

  vendorHash = "sha256-LQdYmsof4CRDBz65Q/YDl+Ll77fvAR/CV/P2RK8a0Lg=";

  meta = with lib; {
    description = "OPA Rego language server";
    mainProgram = "regols";
    homepage = "https://github.com/kitagry/regols";
    license = licenses.mit;
    maintainers = with maintainers; [ alias-dev ];
  };
}

{ lib, fetchFromGitHub }:
let
  version = "v1.29.0";
in
{
  inherit version;

  npmDepsHash = "sha256-s+ZbAL+t+ABvrA3XXPSjlNmRZrwlWI4x9La2YByBI90=";

  src = fetchFromGitHub {
    owner = "sissbruecker";
    repo = "linkding";
    rev = version;
    sha256 = "sha256-uhD6y7Oc2E+veuBtspgiJ/KdqGSLH7w7KIT6MiLOKL4=";
  };

  meta = with lib; {
    homepage = "https://github.com/sissbruecker/linkding";
    license = licenses.mit;
    maintainers = with maintainers; [ rogryza ];
  };
}

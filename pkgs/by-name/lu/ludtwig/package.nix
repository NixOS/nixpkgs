{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ludtwig";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "MalteJanz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WF3tEf3SuXiH35Ny4RGLzvEW7yMsFcnVTX52e5qvK5g=";
  };

  checkType = "debug";

  cargoHash = "sha256-AbT8Jv6v7EVPX5mIplKaBkGrVonA8YWlMvo46coFMzk=";

  meta = with lib; {
    description = "Linter / Formatter for Twig template files which respects HTML and your time.";
    homepage = "https://github.com/MalteJanz/ludtwig";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}

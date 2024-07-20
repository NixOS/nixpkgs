{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "esbuild-config";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bpierre";
    repo = "esbuild-config";
    rev = "v${version}";
    hash = "sha256-u3LgecKfgPSN5xMyqBjeAn4/XswM3iEGbZ+JGrVF1Co=";
  };

  cargoHash = "sha256-Z7uYOjMNxsEmsEXDOIr1zIq4nCgHvHIqpRnRH037b8g=";

  meta = with lib; {
    description = "Config files for esbuild";
    homepage = "https://github.com/bpierre/esbuild-config";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "esbuild-config";
  };
}

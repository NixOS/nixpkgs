{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  cargoHash = "sha256-OQ7zlcWVu3sS/u0B+Ew6VUS4zxntKU2LF63ZcPRUKW0=";

  meta = {
    description = "Config files for esbuild";
    homepage = "https://github.com/bpierre/esbuild-config";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "esbuild-config";
  };
}

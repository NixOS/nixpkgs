{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    # Upstream has no tagged versions
    rev = "3a85a36f1ac08454deab1ed8d2553e0cae00cc1c";
    hash = "sha256-uxK0nciLq4ZKFCoMJrO4dR0tuOBHYpgdZUc/KJ+JA/I=";
  };

  npmDepsHash = "sha256-93MEug2eEL/Hum+RFmXx0JYO6jUygF8QRmL5nTTFyrs=";

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

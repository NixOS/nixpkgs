{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "quai-cli-wallet";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "dominant-strategies";
    repo = "quai-cli-wallet";
    tag = version;
    hash = "sha256-yjchqrwjMNjp9+qBgAJqvrA0BMtHMkeKA04ZSY9Mawc=";
  };

  npmDepsHash = "sha256-tmnc9TDfyj3OP9buWEJH02/Erg+6vELgLinDs9jtcb0=";

  meta = {
    description = "A command-line wallet for Quai Network";
    mainProgram = "quai-cli-wallet";
    homepage = "https://github.com/dominant-strategies/quai-cli-wallet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nintron ];
  };
}

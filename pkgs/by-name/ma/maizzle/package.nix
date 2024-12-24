{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "maizzle";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "maizzle";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-r3HWqfm/BdOfENi5cGdau7ockvNLxnWufWcQepI/RFM=";
  };

  npmDepsHash = "sha256-WlqWOGwmSab+cJWPUFIBWuFwMK4lFQm80PoUfEIIIH8=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for the Maizzle Email Framework";
    homepage = "https://github.com/maizzle/cli";
    license = lib.licenses.mit;
    mainProgram = "maizzle";
    maintainers = with lib.maintainers; [ happysalada ];
  };
}

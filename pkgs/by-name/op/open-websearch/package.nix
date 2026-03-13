{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "open-websearch";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "Aas-ee";
    repo = "open-webSearch";
    rev = "v${version}";
    hash = "sha256-K/xlQKYnR/GywC5lEt0l9KLUG763j1/gMwPi9pwlwKs=";
  };

  npmDepsHash = "sha256-tE+TRsUoegVIZYmqHHKfZN5YnLMHymHYlOzrqijV9Xg=";

  npmBuildScript = "build";

  meta = {
    description = "Web search MCP server";
    mainProgram = "open-websearch";
    homepage = "https://github.com/Aas-ee/open-webSearch";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ "ReStranger" ];
  };
}


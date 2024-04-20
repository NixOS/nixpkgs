{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage (final: prev: {
  pname = "nimlangserver";
  version = "1.2.0";

  # lock.json generated with github.com/daylinmorgan/nnl
  lockFile = ./lock.json;

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "71b59bfa77dabf6b8b381f6e18a1d963a1a658fc";
    hash = "sha256-dznegEhRHvztrNhBcUhW83RYgJpduwdGLWj/tJ//K8c=";
  };

  doCheck = false;

  meta = with lib;
    final.src.meta
    // {
      description = "The Nim language server implementation (based on nimsuggest)";
      homepage = "https://github.com/nim-lang/langserver";
      license = licenses.mit;
      mainProgram = "nimlangserver";
      maintainers = with maintainers; [daylinmorgan];
    };
})

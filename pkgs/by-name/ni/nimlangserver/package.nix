{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage (
  final: prev: rec {
    pname = "nimlangserver";
    version = "1.4.0";

    # lock.json generated with github.com/daylinmorgan/nnl
    lockFile = ./lock.json;

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "langserver";
      rev = "v${version}";
      hash = "sha256-mh+p8t8/mbZvgsJ930lXkcBdUjjioZoNyNZzwywAiUI=";
    };

    doCheck = false;

    meta =
      final.src.meta
      // (with lib; {
        description = "Nim language server implementation (based on nimsuggest)";
        homepage = "https://github.com/nim-lang/langserver";
        license = licenses.mit;
        mainProgram = "nimlangserver";
        maintainers = with maintainers; [ daylinmorgan ];
      });
  }
)

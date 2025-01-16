{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage (
  final: prev: rec {
    pname = "nimlangserver";
    version = "1.8.0";

    # nix build ".#nimlangserver.src"
    # nix run "github:daylinmorgan/nnl" -- result/nimble.lock -o:pkgs/by-name/ni/nimlangserver/lock.json --prefetch-git:bearssl,zlib
    lockFile = ./lock.json;

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "langserver";
      rev = "v${version}";
      hash = "sha256-JyBjHAP/sxQfQ1XvyeZyHsu0Er5D7ePDGyJK7Do5kyk=";
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

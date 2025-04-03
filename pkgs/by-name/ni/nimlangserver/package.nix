{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage (
  final: prev: rec {
    pname = "nimlangserver";
    version = "1.10.2";

    # nix build ".#nimlangserver.src"
    # nix run "github:daylinmorgan/nnl" -- result/nimble.lock -o:pkgs/by-name/ni/nimlangserver/lock.json --git,=,bearssl,zlib
    lockFile = ./lock.json;

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "langserver";
      rev = "v${version}";
      hash = "sha256-CbdlDcEkX/pPXEbIsSM6S9INeBCwgjx7NxonjUJAHrk=";
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

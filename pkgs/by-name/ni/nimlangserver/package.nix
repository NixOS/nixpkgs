{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage (
  final: prev: rec {
    pname = "nimlangserver";
    version = "1.14.0";

    # nix build ".#nimlangserver.src"
    # nix run "github:daylinmorgan/nnl" -- result/nimble.lock -o:pkgs/by-name/ni/nimlangserver/lock.json --git,=,bearssl,zlib
    lockFile = ./lock.json;

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "langserver";
      rev = "v${version}";
      hash = "sha256-IJbuM/AhPgyfe/1ONY8Nb46+gqjduVQOvkgGafgkhY4=";
    };

    doCheck = false;

    meta = final.src.meta // {
      description = "Nim language server implementation (based on nimsuggest)";
      homepage = "https://github.com/nim-lang/langserver";
      license = lib.licenses.mit;
      mainProgram = "nimlangserver";
      maintainers = with lib.maintainers; [ daylinmorgan ];
    };
  }
)

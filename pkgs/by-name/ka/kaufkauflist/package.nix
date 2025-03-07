{
  lib,
  buildPackages,
  fetchFromGitHub,
  buildNpmPackage,
  fetchFromGitea,
  nix-update-script,
}:

let
  esbuild' = buildPackages.esbuild.override {
    buildGoModule =
      args:
      buildPackages.buildGoModule (
        args
        // rec {
          version = "0.21.5";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };
in
buildNpmPackage rec {
  pname = "kaufkauflist";
  version = "4.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kaufkauflist";
    rev = "v${version}";
    hash = "sha256-tvkicYFQewQdcz3e+ETLiCK/c3eNPlxxZNzt+OpIbN0=";
  };

  npmDepsHash = "sha256-HDv6sW6FmKZpUjymrUjz/WG9XrKgLmM6qHMAxP6gBtU=";

  ESBUILD_BINARY_PATH = lib.getExe esbuild';

  postInstall = ''
    mkdir -p $out/share/kaufkauflist $out/share/pocketbase
    cp -vr build/* $out/share/kaufkauflist/
    cp -v pb_schema.json $out/share/pocketbase/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://codeberg.org/annaaurora/kaufkauflist";
    description = "To-do list for shopping or other use cases";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "kaufdbclean";
  };
}

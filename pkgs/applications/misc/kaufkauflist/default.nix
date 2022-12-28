{ lib, buildPackages, buildGoModule, fetchFromGitHub, esbuild, buildNpmPackage, fetchFromGitea }:

let
  esbuild' = buildPackages.esbuild.override {
    buildGoModule = args: buildPackages.buildGoModule (args // rec {
      version = "0.16.15";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-iTAtPHjrBvHweSIiAbkkbBLgjF3v68jipJEzc0I4G04=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
in buildNpmPackage rec {
  pname = "kaufkauflist";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kaufkauflist";
    rev = "v${version}";
    hash = "sha256-feqk2FUs3lcnIgyPzhsow+xO9u7l9+9eZEk9jxRlpG4=";
  };

  npmDepsHash = "sha256-lSnGLK7+ac/wEpAxlpkZS/kgr9F+8WK+nRjCzkrPJt0=";

  ESBUILD_BINARY_PATH = "${lib.getExe esbuild'}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kaufkauflist $out/share/pocketbase
    cp -vr build/* $out/share/kaufkauflist/
    cp -v pb_schema.json $out/share/pocketbase/

    runHook postInstall
  '';

  # Uncomment this when nix-update-script supports Gitea.
  #passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://codeberg.org/annaaurora/kaufkauflist";
    description = "A to-do list for shopping or other use cases";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
  };
}

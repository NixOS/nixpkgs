{ lib, buildPackages, buildGoModule, fetchFromGitHub, esbuild, buildNpmPackage, fetchFromGitea }:

let
  esbuild' = buildPackages.esbuild.override {
    buildGoModule = args: buildPackages.buildGoModule (args // rec {
      version = "0.17.19";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
in buildNpmPackage rec {
  pname = "kaufkauflist";
  version = "2.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kaufkauflist";
    rev = "v${version}";
    hash = "sha256-a7C4yHTHPhL5/p1/XsrMA0PnbIzer6FShDiwUMOg69Y=";
  };

  npmDepsHash = "sha256-uQ4XoaR3JjvPm8EQ2pnDM+x4zjVn4PEHq7BRqVbvFyw=";

  ESBUILD_BINARY_PATH = "${lib.getExe esbuild'}";

  postInstall = ''
    mkdir -p $out/share/kaufkauflist $out/share/pocketbase
    cp -vr build/* $out/share/kaufkauflist/
    cp -v pb_schema.json $out/share/pocketbase/
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

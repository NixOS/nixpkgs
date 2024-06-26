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
          version = "0.19.11";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-NUwjzOpHA0Ijuh0E69KXx8YVS5GTnKmob9HepqugbIU=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };
in
buildNpmPackage rec {
  pname = "kaufkauflist";
  version = "4.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kaufkauflist";
    rev = "v${version}";
    hash = "sha256-x30K2dYxawfebdq//9OmCCG48w0V04tDTXpvRW7lfJI=";
  };

  npmDepsHash = "sha256-E3AXFwiRvrE2Swt7BfSfAoU5mQplSaSJ4q56pVfoEkQ=";

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

{ lib, buildPackages, buildGoModule, fetchFromGitHub, esbuild, buildNpmPackage, fetchFromGitea }:

let
  esbuild' = buildPackages.esbuild.override {
    buildGoModule = args: buildPackages.buildGoModule (args // rec {
<<<<<<< HEAD
      version = "0.17.19";
=======
      version = "0.16.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
<<<<<<< HEAD
        hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
=======
        hash = "sha256-iTAtPHjrBvHweSIiAbkkbBLgjF3v68jipJEzc0I4G04=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
in buildNpmPackage rec {
  pname = "kaufkauflist";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kaufkauflist";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-a7C4yHTHPhL5/p1/XsrMA0PnbIzer6FShDiwUMOg69Y=";
  };

  npmDepsHash = "sha256-uQ4XoaR3JjvPm8EQ2pnDM+x4zjVn4PEHq7BRqVbvFyw=";

  ESBUILD_BINARY_PATH = "${lib.getExe esbuild'}";

  postInstall = ''
    mkdir -p $out/share/kaufkauflist $out/share/pocketbase
    cp -vr build/* $out/share/kaufkauflist/
    cp -v pb_schema.json $out/share/pocketbase/
=======
    hash = "sha256-oXrb6n1oD27bHt/zPWP0REQyCyZXI8BB57pdR/q42gY=";
  };

  npmDepsHash = "sha256-lSnGLK7+ac/wEpAxlpkZS/kgr9F+8WK+nRjCzkrPJt0=";

  ESBUILD_BINARY_PATH = "${lib.getExe esbuild'}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kaufkauflist $out/share/pocketbase
    cp -vr build/* $out/share/kaufkauflist/
    cp -v pb_schema.json $out/share/pocketbase/

    runHook postInstall
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

{ lib
, buildPackages
, fetchFromGitHub
, buildNpmPackage
, fetchFromGitea
, nix-update-script
}:

let
  esbuild' = buildPackages.esbuild.override {
    buildGoModule = args: buildPackages.buildGoModule (args // rec {
      version = "0.18.20";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-mED3h+mY+4H465m02ewFK/BgA1i/PQ+ksUNxBlgpUoI=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
in buildNpmPackage rec {
  pname = "kaufkauflist";
  version = "3.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kaufkauflist";
    rev = "v${version}";
    hash = "sha256-gIwJtfausORMfmZONhSOZ1DRW5CSH+cLDCNy3j+u6d0=";
  };

  npmDepsHash = "sha256-d1mvC72ugmKLNStoemUr8ISCUYjyo9EDWdWUCD1FMiM=";

  ESBUILD_BINARY_PATH = lib.getExe esbuild';

  postInstall = ''
    mkdir -p $out/share/kaufkauflist $out/share/pocketbase
    cp -vr build/* $out/share/kaufkauflist/
    cp -v pb_schema.json $out/share/pocketbase/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://codeberg.org/annaaurora/kaufkauflist";
    description = "A to-do list for shopping or other use cases";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
  };
}

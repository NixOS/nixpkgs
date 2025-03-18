{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
  writeScriptBin,
  stdenv,
  esbuild,
  buildGoModule,
  nodejs_20,
}:
let
  # Patching binwrap by NoOp script
  binwrap = writeScriptBin "binwrap" ''
    #! ${stdenv.shell}
    echo "binwrap called: Returning 0"
    return 0
  '';
  binwrap-install = writeScriptBin "binwrap-install" ''
    #! ${stdenv.shell}
    echo "binwrap-install called: Doing nothing"
  '';

  ESBUILD_BINARY_PATH = lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
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
    }
  );
in
buildNpmPackage rec {
  pname = "elm-pages";
  version = "3.0.20";
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "dillonkearns";
    repo = "elm-pages";
    rev = "v${version}";
    hash = "sha256-Z319PuVnMCmDB7ew6wbFHYFGBLmBVNpE79phLXjIObs=";
  };

  npmDepsHash = "sha256-KQEkPtNxrsr2NAOeg79rkvP5Js5Gfox+Y/GqtRhBepE=";

  dontNpmBuild = true;

  postPatchPhase = ''
    sed -i 's/"esbuild": "0\.19\.12"/"esbuild": "0.21.5"/' package.json
  '';

  patches = [ ./read-only.patch ./init-read-only.patch ];

  nativeBuildInputs = [
    binwrap
    binwrap-install
  ];

  versionCheckProgramArg = [ "--version" ];

  postFixup = ''
    wrapProgram $out/bin/elm-pages --prefix PATH : ${
      with elmPackages;
      lib.makeBinPath [
        elm
        elm-review
        elm-optimize-level-2
      ]
    }
  '';

  env.CYPRESS_INSTALL_BINARY = "0";

  meta = {
    description = "A statically typed site generator for Elm.";
    homepage = "https://github.com/dillonkearns/elm-pages";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      turbomack
      jali-clarke
    ];
  };
}

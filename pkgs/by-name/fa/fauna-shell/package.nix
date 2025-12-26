{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  esbuild,
  buildGoModule,
}:
let
  esbuild' = esbuild.override {
    buildGoModule =
      args:
      buildGoModule (
        args
        // rec {
          version = "0.24.0";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-czQJqLz6rRgyh9usuhDTmgwMC6oL5UzpwNFQ3PKpKck=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };
in

buildNpmPackage (finalAttrs: {
  pname = "fauna-shell";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "fauna";
    repo = "fauna-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JbTS54e1pNxoqTAlEdOqKqkEyAzFJLI6he7/jivVPzI=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-RNgx3Oorc/+nHHZHdOmyA9Q3fCW7yaAzX0DqHbCMqt0=";

  npmFlags = [ "--ignore-scripts" ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  # While this errors, it makes the build complete successfully. Therefore, ????
  preBuild = ''
    npm rebuild --verbose cpu-features
  '';

  npmBuildScript = "build:app";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Interactive shell for FaunaDB";
    homepage = "https://github.com/fauna/fauna-shell";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "fauna";
  };
})

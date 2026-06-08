{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  esbuild,
  buildGoModule,
  nodejs_22,
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

  # upstream's package-lock.json is missing entries needed by npm >= 11
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-OH/ippCHRy7glq+wXBwnHIVCO6yL5CItng/vCKv+0fQ=";

  nodejs = nodejs_22;

  npmFlags = [ "--ignore-scripts" ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  # ssh2's optional cpu-features native module needs node-gyp building to satisfy esbuild's bundler
  preBuild = ''
    npm rebuild cpu-features
  '';

  npmBuildScript = "build:app";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Interactive shell for FaunaDB";
    homepage = "https://github.com/fauna/fauna-shell";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "fauna";
  };
})

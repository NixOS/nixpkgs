{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs_22,
  npmHooks,
  testers,
}:

let
  source = import ./source.nix;

  inherit (source)
    version
    vendorHash
    ;

  src = fetchFromGitHub {
    owner = "mailtrap";
    repo = "mailtrap-local";
    tag = "v${version}";
    hash = source.hash;
  };

  # Keep the UI separate because buildGoModule's go-modules derivation
  # inherits attributes from the package derivation.
  ui = stdenv.mkDerivation {
    pname = "mailtrap-local-ui";
    inherit src version;

    sourceRoot = "${src.name}/frontend";

    npmDeps = fetchNpmDeps {
      inherit src;
      sourceRoot = "${src.name}/frontend";
      hash = source.npmDepsHash;
    };

    nativeBuildInputs = [
      nodejs_22
      npmHooks.npmConfigHook
    ];

    buildPhase = ''
      runHook preBuild
      npm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mv dist $out
      runHook postInstall
    '';
  };
in
buildGo126Module (finalAttrs: {
  pname = "mailtrap-local";
  inherit src version vendorHash;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preBuild = ''
    rm -rf cmd/mailtrap-local/dist
    cp -r ${ui} cmd/mailtrap-local/dist
    cp docs/api/openapi.yaml cmd/mailtrap-local/openapi.yaml
  '';

  postInstall = ''
    ln -s mailtrap-local $out/bin/mailtrap-sendmail
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "mailtrap-local --version";
    };
    updateScript = {
      supportedFeatures = [ "commit" ];
      command = ./update.sh;
    };
    inherit ui;
  };

  meta = {
    description = "Local email sandbox and catcher with SMTP, web UI, and JSON API";
    homepage = "https://github.com/mailtrap/mailtrap-local";
    changelog = "https://github.com/mailtrap/mailtrap-local/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leonid-shevtsov ];
    mainProgram = "mailtrap-local";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

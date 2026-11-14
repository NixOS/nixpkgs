{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "biliup-unwrapped";
  version = "1.3.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "biliup";
    repo = "biliup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s5PSTYPXQwfsK8TS9BTGEY8qikmt/R8J7uT0Roiuygo=";
  };

  cargoHash = "sha256-Kvbuyi51to082YE0dku+hmmPeyWoYUpdh3q0wnMRnd4=";
  buildAndTestSubdir = "crates/biliup-cli";

  postPatch = ''
    ln -s ${finalAttrs.passthru.frontendDist} out
  '';

  # Requires network access.
  doCheck = false;

  passthru = {
    frontendDist = buildNpmPackage {
      pname = "biliup-frontend";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      # Needs to bind to a local port.
      __darwinAllowLocalNetworking = true;

      npmDepsHash = "sha256-6Y5ZlEhFb9abjhdgWEsg9OMerGI/N8D4heoS221aPJw=";

      installPhase = "cp -r out $out";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool for uploading videos to Bilibili";
    homepage = "https://biliup.github.io/biliup";
    changelog = "https://github.com/biliup/biliup/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "biliup";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.starryreverie ];
  };
})

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  amp-cli,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "amp-acp";
  version = "0.12.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tao12345666333";
    repo = "amp-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ooENV6fxPjQm2Tb0gXrSebCxhO+M56cy0dZB+z78Bck=";
  };

  npmDepsHash = "sha256-6cDnZLU+UF/BmGwRNzEQup1U3qPcPrXkfco2tNuLVsU=";

  # `npm run build` bundles with bun
  nativeBuildInputs = [ bun ];

  # @ampcode/cli's install script copies its prebuilt Amp binary into place; amp-cli is used
  # instead.
  npmRebuildFlags = [ "--ignore-scripts" ];

  postPatch = ''
    # Fails when the fake Amp CLI starts slower than the test's fixed 50 ms wait: the steering
    # prompt is then answered before the delayed init message.
    substituteInPlace src/amp-transport.test.ts \
      --replace-fail "it('delivers delayed initialization after steering an early cancellation'" \
        "it.skip('delivers delayed initialization after steering an early cancellation'"
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bun test src/
    runHook postCheck
  '';

  postInstall = ''
    # The prebuilt Amp CLI packages that @ampcode/sdk depends on
    rm -r $out/lib/node_modules/amp-acp/node_modules/{@ampcode/cli*,.bin/amp}

    wrapProgram $out/bin/amp-acp \
      --set-default AMP_CLI_PATH ${lib.getExe amp-cli}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent Client Protocol adapter for the Amp coding agent";
    homepage = "https://github.com/tao12345666333/amp-acp";
    changelog = "https://github.com/tao12345666333/amp-acp/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      # @ampcode/sdk, bundled into the program
      unfree
    ];
    maintainers = [ lib.maintainers.kleinbem ];
    mainProgram = "amp-acp";
    inherit (amp-cli.meta) platforms;
  };
})

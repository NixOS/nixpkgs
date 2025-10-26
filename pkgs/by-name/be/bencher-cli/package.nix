{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bencher-cli";
  version = "v0.5.6";

  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    tag = finalAttrs.version;
    hash = "sha256-iv0BScnDYVtkMnvGv3JysamuOANRNpvY8+ZC32aa2iA=";
  };

  cargoHash = "sha256-9Uf2XvBjZUudrfrLQCu4lCsGLx1zUz95nkNrMHTekm8=";

  cargoBuildFlags = [
    "--package"
    "bencher_cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # The default features include `plus` which has a custom license
  buildNoDefaultFeatures = true;

  postPatch = ''
    # Remove mold linker configuration which is not available in the Nix build environment
    rm -f .cargo/config.toml
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bencher CLI";
    longDescription = ''
      Bencher is a suite of continuous benchmarking tools.
    '';
    homepage = "https://bencher.dev/";
    changelog = "https://github.com/bencherdev/bencher/blob/${finalAttrs.version}/services/console/src/chunks/docs-reference/changelog/en/changelog.mdx";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ michaelvanstraten ];
    mainProgram = "bencher";
    platforms = lib.platforms.all;
  };
})

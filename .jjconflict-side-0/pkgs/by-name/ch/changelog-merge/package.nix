{
  lib,
  fetchCrate,
  gitMinimal,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "changelog-merge";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-msv8rLlkKX7AwCZOR3IELGRgGlpaY/+IiIG4BLAX5i0=";
  };

  cargoHash = "sha256-cmSYgkTuEprJgaQ784nEa5ouF0aI44iNuRR/3IcNp1k=";

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic three-way merging for Keep a Changelog";
    homepage = "https://github.com/cachix/changelog-merge";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.domenkozar ];
    mainProgram = "changelog-merge";
  };
})

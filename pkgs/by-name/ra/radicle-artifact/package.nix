{
  lib,
  rustPlatform,
  fetchFromRadicle,
  stdenv,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-artifact";
  version = "0.23.3";

  __structuredAttrs = true;

  src = fetchFromRadicle {
    seed = "radicle.norman.life";
    repo = "z4VYyJ9KuwMNkXGQnmKuGPGKw3inv";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-FB2VxpKXd/ZG4Ffk0IOWEi0GaURTvLGqjIQ0ipsNT84=";
  };

  cargoHash = "sha256-Kk5yKuNOEf3gu7XNzsQJ54tsCExg2uRzmp8LcVDAn0E=";

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # tests segfault on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure artifact distribution for Radicle";
    homepage = "https://radicle.network/nodes/radicle.norman.life/rad:z4VYyJ9KuwMNkXGQnmKuGPGKw3inv";
    changelog = "https://radicle.network/nodes/radicle.norman.life/rad:z4VYyJ9KuwMNkXGQnmKuGPGKw3inv/tree/CHANGELOG.md";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    teams = [ lib.teams.radicle ];
    mainProgram = "rad-artifact";
  };
})

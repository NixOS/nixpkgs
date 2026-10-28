{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macos-defaults";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dsully";
    repo = "macos-defaults";
    tag = finalAttrs.version;
    hash = "sha256-SIar0QceNQs2tEYIcwwG2u+2Aq3IieOm4sIEX6hXilk=";
  };

  cargoHash = "sha256-0jB9lpguS40n1CrfJsnyZQvfnprC8pCx27xu1RRjaqI=";

  checkFlags = [
    # accesses home dir
    "--skip=defaults::tests::plist_path_tests"
    # accesses system_profiler
    "--skip=defaults::tests::test_get_hardware_uuid"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for managing macOS defaults declaratively via YAML files";
    homepage = "https://github.com/dsully/macos-defaults";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josh ];
    mainProgram = "macos-defaults";
    platforms = lib.platforms.darwin;
  };
})

{
  fetchFromGitHub,
  rustPlatform,
  lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sledtool";
  version = "0.1.3";

  useFetchCargoVendor = true;
  cargoHash = "sha256-BrI4Xq3Kuj06aPKSXNhCKCWZurO1npIsbBil3MrbQfk=";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "sledtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8D1zrRecU3s4EWKRAnnQ8Ga/kvKR0TCG6agoBCw+bEI=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "sledtool";
    description = "CLI tool to work with Sled key-value databases";
    homepage = "https://github.com/vi/sledtool";
    changelog = "https://github.com/vi/sledtool/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cilki ];
  };
})

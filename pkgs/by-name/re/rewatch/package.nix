{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rewatch";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rewatch";
    tag = "v${version}";
    hash = "sha256-a8pWExKziD9AFDvsCZAES7xJhuw9OtvczW54g3DSuso=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-evmpyBOKOI8Vb1PguTxnTbBvJ+qQg85Kv8ByC3y1n5c=";

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative build system for the Rescript Compiler";
    homepage = "https://github.com/rescript-lang/rewatch";
    changelog = "https://github.com/rescript-lang/rewatch/releases/tag/v${version}";
    mainProgram = "rewatch";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mit;
  };
}

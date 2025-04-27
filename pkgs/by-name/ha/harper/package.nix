{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-+XO81A7F3QOGcDm/keqUHbURCQfzAHRiAlQmNzGo1IU=";
  };

  buildAndTestSubdir = "harper-ls";
  useFetchCargoVendor = true;
  cargoHash = "sha256-EwWBqVTkBH4p1ljBitXtGkjUlx96Uajxc0z7DDkGawo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
    ];
    mainProgram = "harper-ls";
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-vhaIDzjOG43+zxJU1BTPNPTmbDkLqFo0NRfvYcJSvSo=";
  };

  buildAndTestSubdir = "harper-ls";
  useFetchCargoVendor = true;
  cargoHash = "sha256-6f8zJyz36Da7OvqWBE1w5IsRa8dNulSxLrQiTqjEbKo=";

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

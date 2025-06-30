{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rewatch";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rewatch";
    tag = "v${version}";
    hash = "sha256-HP4GwRGtt3iUS/B8ouwZKlr5YQgWy5tRJi38MXe20xM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h2u53asRmRMHo1uVlR2uy2UwJyJyjSHX2182F8DqYfE=";

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

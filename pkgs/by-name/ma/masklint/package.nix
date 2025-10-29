{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  pname = "masklint";
  inherit version;

  src = fetchFromGitHub {
    owner = "brumhard";
    repo = "masklint";
    rev = "v${version}";
    hash = "sha256-Dku2pDUCblopHtoj6viUqHVpVH5GDApp+QLjor38j7g=";
  };

  cargoHash = "sha256-TDk7hEZ628iUnKI0LMBtsSAVNF6BGukHwB8kh70eo4U=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lint your mask targets";
    homepage = "https://github.com/brumhard/masklint";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "masklint";
  };
}

{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-nix-repl";
  version = "0.5.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-vLEWrR10AP0xl33RXtafdepAoEF2DZ4DlyXvThqSN1M=";
  };

  cargoHash = "sha256-+KjD2PuHOQIDoJrramlLkUO6sHHlNiTwOo/Ogs0OshY=";

  nativeInstallCheckInuts = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "mdBook preprocessor to provide nix-repl functionality within mdbook";
    mainProgram = "mdbook-nix-repl";
    homePage = "https://github.com/saylesss88/mdbook-nix-repl";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.saylesss88 ];
  };
}

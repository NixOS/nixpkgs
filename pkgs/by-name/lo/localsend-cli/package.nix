{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "localsend-cli";
  version = "1.18.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "localsend";
    repo = "localsend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hP4whBkBQ/FEnUOjgeC+HIzrWhtbME6HGxmwwvTSSeI=";
  };

  cargoHash = "sha256-lgg+f7gLHUG4pYUAJW+nIrS8vUX4x+daupgCG8jct/Q=";

  cargoBuildFlags = [
    "--package"
    "localsend-cli"
  ];

  checkInputs = [
    cacert
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source cross-platform alternative to AirDrop (cli version)";
    homepage = "https://github.com/localsend/localsend";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "localsend-cli";
  };
})

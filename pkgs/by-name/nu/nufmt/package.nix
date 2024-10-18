{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  llvmPackages,
  nix-update-script,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "nufmt";
  version = "0-unstable-2024-10-15";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "37b473be178fd752b5bf421f8b20f48209e9c2ec";
    hash = "sha256-BrVWw6oklG70UomKDv5IBvoFIjtpajHKV37fh4fnK3E=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      IOKit
    ]
  );

  env.LIBCLANG_PATH = lib.optionalString stdenv.cc.isClang "${llvmPackages.libclang.lib}/lib";

  cargoHash = "sha256-eKQJanQ9ax5thc2DuO0yIgovor+i5Soylw58I2Y5cHw=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iogamaster
      khaneliman
    ];
    mainProgram = "nufmt";
  };
}

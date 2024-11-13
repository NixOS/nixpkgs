{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  apple-sdk_11,
  llvmPackages,
  nix-update-script,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2024-10-20";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "decc88ef8e11a14081c2dd86c6ea0c94d6d2861d";
    hash = "sha256-AurQGIZDYOkMMyAEXP01QziISQcSME3GFtvqjCDoeiw=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_11
  ];

  env.LIBCLANG_PATH = lib.optionalString stdenv.cc.isClang "${lib.getLib llvmPackages.libclang}/lib";

  cargoHash = "sha256-5DS6pTYGOQ4qay6+YiUstInRX17n3RViNxKXtFZ6J3k=";

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

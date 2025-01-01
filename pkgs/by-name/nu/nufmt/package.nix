{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  apple-sdk_11,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "628a3b73ea637c96f2c191ae066cf1cecadeafa3";
    hash = "sha256-ideILLOawU6BNawmr4lqt2LGkf29wvlwQe9gqgdYRiI=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_11
  ];

  cargoHash = "sha256-MHZlXmHAYIiaB6Isutqjrh45jppRzTZRSE3VqzpFBBA=";

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

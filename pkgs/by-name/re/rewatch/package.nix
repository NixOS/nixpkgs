{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  apple-sdk_11,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rewatch";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rewatch";
    tag = "v${version}";
    hash = "sha256-y+0tBwGa7Fjrnd3O7CwZjapgXJojfgXBZyqAW3cz1Zk=";
  };

  cargoHash = "sha256-cZTA50gm7o+vBaRNjpZI0LQkXaHIukVTBXoYMUubZgw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_11
  ];

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

{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pkg-config,
  openssl,
  libgit2,
}:

rustPlatform.buildRustPackage rec {
  pname = "klipper-estimator";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
    hash = "sha256-EjfW2qeq0ehGhjE2Psz5g/suYMZPvtQi2gaYb+NCa2U=";
  };

  cargoHash = "sha256-wMgFkzgoHjvE+5t+cA5OW2COXbUj/5tWXz0Zp9cd5lw=";

  env.TOOL_VERSION = "v${version}";

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libgit2
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Tool for determining the time a print will take using the Klipper firmware";
    homepage = "https://github.com/Annex-Engineering/klipper_estimator";
    changelog = "https://github.com/Annex-Engineering/klipper_estimator/releases/tag/v${version}";
    mainProgram = "klipper_estimator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
}

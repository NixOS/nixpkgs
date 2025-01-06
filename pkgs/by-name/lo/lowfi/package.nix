{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "lowfi";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = version;
    hash = "sha256-pfvTOoWsXukZTfev9+Ifcp3YYIqtYZgmEVPHuqD4IsM=";
  };

  cargoHash = "sha256-oRZ44IZRli0PNnQkeplD0ggh1ipDlyehNBTpxrgl/JI=";

  buildFeatures = [ "mpris" ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreAudio
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  meta = {
    description = "Extremely simple lofi player";
    homepage = "https://github.com/talwat/lowfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zsenai ];
    mainProgram = "lowfi";
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "lowfi";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = version;
    hash = "sha256-0Oim1nGll76APjjfNCuJgjOlEJxAU6vZteECEFhsWkI=";
  };

  cargoHash = "sha256-vInuM96TJuewhFafDkhOiZiyxwc6SeBsSH8Fs8YIRRs=";

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [ "mpris" ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
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

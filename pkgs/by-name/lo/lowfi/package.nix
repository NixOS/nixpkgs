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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = version;
    hash = "sha256-RSdfZ0GrNhPcqDWutJW0VlplbpBNBCpSvw91fpl0d4E=";
  };

  cargoHash = "sha256-OAg3ZpBmuINkc6KZJGKvYFnpv9hVbwlnOEP5ICtYh28=";

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

  checkFlags = [
    # Skip this test as it doesn't work in the nix sandbox
    "--skip=tests::tracks::list::download"
  ];

  meta = {
    description = "Extremely simple lofi player";
    homepage = "https://github.com/talwat/lowfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zsenai ];
    mainProgram = "lowfi";
  };
}

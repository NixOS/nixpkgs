{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  alsa-lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lowfi";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "lowfi";
    tag = finalAttrs.version;
    hash = "sha256-t61R68cuAEAjyY5cR2rpTa+pSE3DDDct9G4p/aeTgsQ=";
  };

  cargoHash = "sha256-ogoQWcS6htU515xjJW7jQYqpfHAQ48a8QaaBPvkGrXg=";

  buildFeatures = [ "scrape" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "mpris" ];

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
})

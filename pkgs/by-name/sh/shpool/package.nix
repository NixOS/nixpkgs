{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  linux-pam,
  testers,
  shpool,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shpool";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "shell-pool";
    repo = "shpool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iN4ZPayOUhbP3WlQIIyIN73PxH3CFgsQELWt8prtTJo=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace systemd/shpool.service \
      --replace-fail '/usr/bin/shpool' "$out/bin/shpool"
  '';

  cargoHash = "sha256-bWA0UZLr/z9MWLrp0yxblFTZwSOEIheBhmx71Ftnbcg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ linux-pam ];

  # The majority of tests rely on impure environment
  # (such as systemd socket, ssh socket), and some of them
  # have race conditions. They don't print their full name,
  # tried skipping them but failed
  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm444 systemd/shpool.service -t $out/lib/systemd/user
    install -Dm444 systemd/shpool.socket -t $out/lib/systemd/user
  '';

  passthru.tests.version = testers.testVersion {
    command = "shpool version";
    package = shpool;
  };

  meta = {
    description = "Persistent session management like tmux, but more lightweight";
    homepage = "https://github.com/shell-pool/shpool";
    license = lib.licenses.asl20;
    mainProgram = "shpool";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

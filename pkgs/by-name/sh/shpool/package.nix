{
  lib,
  rustPlatform,
  fetchFromGitHub,
  linux-pam,
  testers,
  shpool,
}:

rustPlatform.buildRustPackage rec {
  pname = "shpool";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "shell-pool";
    repo = "shpool";
    rev = "v${version}";
    hash = "sha256-6gfK71uM6IOP571Jzv3QPPKITaRteXyySZAstH0e+/M=";
  };


  postPatch = ''
    substituteInPlace systemd/shpool.service \
      --replace-fail '/usr/bin/shpool' "$out/bin/shpool"
  '';

  cargoHash = "sha256-rJ+Avq/6y68xEcJ+EeFVhFaSWJyC+x0a46cclVsTE4Q=";

  buildInputs = [
    linux-pam
  ];

  # The majority of tests rely on impure environment
  # (such as systemd socket, ssh socket), and some of them
  # have race conditions. They don't print their full name,
  # tried skipping them but failed
  doCheck = false;

  postInstall = ''
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
    platforms = lib.platforms.linux;
  };
}

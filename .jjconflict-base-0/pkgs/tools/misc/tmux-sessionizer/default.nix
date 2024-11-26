{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  Security,
  testers,
  tmux-sessionizer,
  installShellFiles,
}:
let

  name = "tmux-sessionizer";
  version = "0.4.4";

in
rustPlatform.buildRustPackage {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = "v${version}";
    hash = "sha256-4xwpenoAVGKdVO3eSS4BhaEcwpNPGA5Ozie53focDlA=";
  };

  cargoHash = "sha256-ajeCB1w/JHMT5e7mSwsh++lzLNfp0qfutONStpJpFDo=";

  passthru.tests.version = testers.testVersion {
    package = tmux-sessionizer;
    version = version;
  };

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tms \
      --bash <($out/bin/tms --generate bash) \
      --fish <($out/bin/tms --generate fish) \
      --zsh <($out/bin/tms --generate zsh)
  '';

  meta = with lib; {
    description = "Fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [
      vinnymeller
      mrcjkb
    ];
    mainProgram = "tms";
  };
}

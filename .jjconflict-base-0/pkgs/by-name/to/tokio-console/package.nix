{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  protobuf,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    hash = "sha256-KqX+s1oQIRyqAP+0iGrZiT8lB+cGviY1vtHaXy5Q6TA=";
  };

  cargoHash = "sha256-QJdTysoVIbeLsTMt62Q355S8zx8tNCikZAyeRs7cz4o=";

  buildAndTestSubdir = "tokio-console";

  nativeBuildInputs = [
    installShellFiles
    protobuf
  ];

  # uses currently unstable tokio features
  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # tests depend upon git repository at test execution time
    "--skip bootstrap"
    "--skip config::tests::args_example_changed"
    "--skip config::tests::toml_example_changed"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tokio-console \
      --bash <($out/bin/tokio-console --log-dir $(mktemp -d) gen-completion bash) \
      --fish <($out/bin/tokio-console --log-dir $(mktemp -d) gen-completion fish) \
      --zsh <($out/bin/tokio-console --log-dir $(mktemp -d) gen-completion zsh)
  '';

  meta = with lib; {
    description = "Debugger for asynchronous Rust code";
    homepage = "https://github.com/tokio-rs/console";
    mainProgram = "tokio-console";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}

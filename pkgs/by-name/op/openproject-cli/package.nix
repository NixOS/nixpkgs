{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  go_1_25,
}:

buildGoModule rec {
  pname = "openproject-cli";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "opf";
    repo = "openproject-cli";
    rev = version;
    hash = "sha256-5dovK9A2l+bT6hLGw8gyciK1p0ucGmdEX3qdC9zvJR4=";
  };

  vendorHash = "sha256-HiS8yHb8o2xdsCDKmebhJOCZpG/3rmE3zKcoaMYTxTE=";

  # specify Go version explicitly
  go = go_1_25;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # Create the canonical alias
    ln -s "$out/bin/openproject-cli" "$out/bin/op"

    # Set a writable HOME to avoid /homeless-shelter errors
    export HOME="$PWD/tmp-home"
    mkdir -p "$HOME"

    # Generate completions into a temporary directory
    mkdir -p completions
    PATH="$out/bin:$PATH"

    op completion bash > completions/op
    op completion zsh > completions/op.zsh
    op completion fish > completions/op.fish

    # Install to correct standard locations
    installShellCompletion \
      --bash completions/op \
      --zsh completions/op.zsh \
      --fish completions/op.fish
  '';

  meta = with lib; {
    description = "CLI for OpenProject API v3";
    homepage = "https://github.com/opf/openproject-cli";
    license = licenses.gpl3Only; # check LICENSE file to confirm
    platforms = platforms.unix;
    mainProgram = "openproject-cli";
  };
}

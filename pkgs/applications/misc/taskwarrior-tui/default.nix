{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.23.7";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-D7+C02VlE42wWQSOkeTJVDS4rWnGB06RTZ7tzdpYmZw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "task-hookrs-0.7.0" = "sha256-EGnhUgYxygU3JrYXQPE9SheuXWS91qEwR+w3whaYuYw=";
    };
  };

  postInstall = ''
    installManPage docs/taskwarrior-tui.1
    installShellCompletion completions/taskwarrior-tui.{bash,fish} --zsh completions/_taskwarrior-tui
  '';

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
<<<<<<< HEAD
  version = "0.25.4";
=======
  version = "0.23.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-M8tiEUPfP5EWfPp7i6r0lpHC5ZUsEYeEKVz5gUpe4+A=";
  };

  cargoHash = "sha256-B5peoyT/+miHXyoRGFLUv9qFzZZFsExrI46Zy0K7NL4=";

=======
    sha256 = "sha256-D7+C02VlE42wWQSOkeTJVDS4rWnGB06RTZ7tzdpYmZw=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ installShellFiles ];

  # Because there's a test that requires terminal access
  doCheck = false;

<<<<<<< HEAD
=======
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "task-hookrs-0.7.0" = "sha256-EGnhUgYxygU3JrYXQPE9SheuXWS91qEwR+w3whaYuYw=";
    };
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

{ lib
, buildGoModule
, fetchFromSourcehut
, installShellFiles
, scdoc
}:

buildGoModule rec {
  pname = "soju";
<<<<<<< HEAD
  version = "0.6.2";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Icz6oIXLnLe75zuB8Q862I1ado5GpGZBJezrH7F7EJs=";
=======
    hash = "sha256-e3yA8gXuLxRzJIQQIjhajIOWVtikd+gNVxbhzfy56b0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-iT/QMm6RM6kvw69Az+aLTtBuaCX7ELAiYlj5wXAtBd4=";

  subPackages = [
    "cmd/soju"
    "cmd/sojuctl"
    "contrib/migrate-db"
    "contrib/znc-import"
  ];

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  ldflags = [ "-s" "-w" ];

  postBuild = ''
    make doc/soju.1
  '';

  postInstall = ''
    installManPage doc/soju.1
  '';

  preCheck = ''
    # Test all targets.
    unset subPackages

    # Disable a test that requires an additional service.
    rm database/postgres_test.go
  '';

  meta = with lib; {
    description = "A user-friendly IRC bouncer";
    longDescription = ''
      soju is a user-friendly IRC bouncer. soju connects to upstream IRC servers
      on behalf of the user to provide extra functionality. soju supports many
      features such as multiple users, numerous IRCv3 extensions, chat history
      playback and detached channels. It is well-suited for both small and large
      deployments.
    '';
    homepage = "https://soju.im";
    changelog = "https://git.sr.ht/~emersion/soju/refs/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ azahi malte-v ];
  };
}

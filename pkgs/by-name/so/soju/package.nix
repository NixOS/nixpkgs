{ lib
, buildGoModule
, fetchFromSourcehut
, installShellFiles
, scdoc
}:

buildGoModule rec {
  pname = "soju";
  version = "0.8.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
    hash = "sha256-K7Dgc1HQ6+GnjraQNcK9LOFxUIoKKWro1mWKDZFwLiE=";
  };

  vendorHash = "sha256-4Yl87Gk/HykjIyNpRfgthLf6b+v7kxmONIhYBWVXi0I=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  ldflags = [ "-s" "-w" ];

  postBuild = ''
    make doc/soju.1 doc/sojuctl.1
  '';

  postInstall = ''
    installManPage doc/soju.1 doc/sojuctl.1
  '';

  preCheck = ''
    # Disable a test that requires an additional service.
    rm database/postgres_test.go
  '';

  meta = with lib; {
    description = "User-friendly IRC bouncer";
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
    maintainers = with maintainers; [ azahi malte-v jtbx ];
  };
}

{ lib
, buildGoModule
, fetchFromSourcehut
, installShellFiles
, scdoc
}:

buildGoModule rec {
  pname = "soju";
  version = "0.5.2";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
    hash = "sha256-lpLWqaSFx/RJg73n5XNN/qUXHfZsBkbABoYcgxpK3rU=";
  };

  vendorHash = "sha256-n1wwi7I2hDLOe08RkJOiopDUGI6uhipNpBdeOLARIoU=";

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

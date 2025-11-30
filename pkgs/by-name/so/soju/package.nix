{
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
  scdoc,
  nixosTests,
}:

buildGoModule rec {
  pname = "soju";
  version = "0.10.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "emersion";
    repo = "soju";
    rev = "v${version}";
    hash = "sha256-kOV7EFRr+Ca9bQ1bdDMNf1FiiniIHDebsf5SpbJshsI=";
  };

  vendorHash = "sha256-NP4njea0hcklxWFoxPQqrvyWExeRP/TOzUJcamRnx+s=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/emersion/soju/config.DefaultPath=/etc/soju/config"
    "-X codeberg.org/emersion/soju/config.DefaultUnixAdminPath=/run/soju/admin"
  ];

  postBuild = ''
    make doc/soju.1 doc/sojuctl.1
  '';

  checkFlags = [ "-skip TestPostgresMigrations" ];

  postInstall = ''
    installManPage doc/soju.1 doc/sojuctl.1
  '';

  passthru.tests.soju = nixosTests.soju;

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
    changelog = "https://codeberg.org/emersion/soju/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      azahi
      malte-v
    ];
    mainProgram = "sojuctl";
  };
}

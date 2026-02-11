{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  openssh,
  libxcrypt,
  testers,
  shellhub-agent,
}:

buildGoModule (finalAttrs: {
  pname = "shellhub-agent";
  version = "0.21.5";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0adBDz9oHb+Wo1/BucMPavX/4xZidjQYNVA3O475JEo=";
  };

  modRoot = "./agent";

  vendorHash = "sha256-zBT3kQhn6RhgcP/5FBEhKo1oPl9GgFQqWGsBUgrDwW4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.AgentVersion=v${finalAttrs.version}"
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.version = testers.testVersion {
      package = shellhub-agent;
      command = "agent --version";
      version = "v${finalAttrs.version}";
    };
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libxcrypt ];

  postInstall = ''
    wrapProgram $out/bin/agent --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = {
    description = "Enables easy access any Linux device behind firewall and NAT";
    longDescription = ''
      ShellHub is a modern SSH server for remotely accessing Linux devices via
      command line (using any SSH client) or web-based user interface, designed
      as an alternative to _sshd_. Think ShellHub as centralized SSH for the the
      edge and cloud computing.
    '';
    homepage = "https://shellhub.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    platforms = lib.platforms.linux;
    mainProgram = "agent";
  };
})

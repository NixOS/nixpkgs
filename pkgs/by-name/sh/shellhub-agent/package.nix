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

buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    hash = "sha256-C6ez20eTMGGvORqB00F3mSciExlOmcG7iKvz9F3Sls8=";
  };

  modRoot = "./agent";

  vendorHash = "sha256-sXyM9tPsIW+x5zjiah1sr+iGq2JC2VcLHKvoFW6yr3M=";

  ldflags = [
    "-s"
    "-w"
    "-X main.AgentVersion=v${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.version = testers.testVersion {
      package = shellhub-agent;
      command = "agent --version";
      version = "v${version}";
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
}

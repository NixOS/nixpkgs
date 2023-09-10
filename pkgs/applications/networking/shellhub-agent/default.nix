{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, makeWrapper
, openssh
, libxcrypt
, testers
, shellhub-agent
}:

buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    hash = "sha256-OvXbc3feCatyubbRZlaiXvGP59ApyAS0b0Z6SeJsZnE=";
  };

  modRoot = "./agent";

  vendorHash = "sha256-qQRi4GeepRpYPhE5ftUj01tMCqBh5txbizfkVXmrgOQ=";

  ldflags = [ "-s" "-w" "-X main.AgentVersion=v${version}" ];

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

  meta = with lib; {
    description =
      "Enables easy access any Linux device behind firewall and NAT";
    longDescription = ''
      ShellHub is a modern SSH server for remotely accessing Linux devices via
      command line (using any SSH client) or web-based user interface, designed
      as an alternative to _sshd_. Think ShellHub as centralized SSH for the the
      edge and cloud computing.
    '';
    homepage = "https://shellhub.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
    platforms = platforms.linux;
  };
}

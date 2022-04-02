{ lib
, buildGoModule
, fetchFromGitHub
, gitUpdater
, makeWrapper
, openssh
}:

buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    sha256 = "A1634b3uxlILMpx/9jpCIApqAqofvD4ZPasVKL29Gtc=";
  };

  modRoot = "./agent";

  vendorSha256 = "sha256-LxJtLQr8djoRGznT5hL2agTgtZY6pFS8Zo0BwHDmugc=";

  ldflags = [ "-s" "-w" "-X main.AgentVersion=v${version}" ];

  passthru = {
    updateScript = gitUpdater {
      inherit pname version;
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
  };

  nativeBuildInputs = [ makeWrapper ];

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

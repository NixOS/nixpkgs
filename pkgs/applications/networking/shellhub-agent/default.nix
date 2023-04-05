{ lib
, buildGo120Module
, fetchFromGitHub
, gitUpdater
, makeWrapper
, openssh
, libxcrypt
}:

buildGo120Module rec {
  pname = "shellhub-agent";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
    sha256 = "d5ESQQgBPUFe2tuCbeFIqiWPpr9wUczbXLc5QdXurXY=";
  };

  modRoot = "./agent";

  vendorSha256 = "sha256-/85rIBfFBpXYrsCBDGVzXfAxO6xXQ8uTL2XeEPKQwDQ=";

  ldflags = [ "-s" "-w" "-X main.AgentVersion=v${version}" ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
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

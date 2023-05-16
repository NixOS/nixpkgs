{ lib
<<<<<<< HEAD
, buildGoModule
, fetchFromGitHub
, nix-update-script
=======
, buildGo120Module
, fetchFromGitHub
, gitUpdater
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeWrapper
, openssh
, libxcrypt
, testers
, shellhub-agent
}:

<<<<<<< HEAD
buildGoModule rec {
  pname = "shellhub-agent";
  version = "0.12.5";
=======
buildGo120Module rec {
  pname = "shellhub-agent";
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "shellhub-io";
    repo = "shellhub";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+2YYTnQDU9AkCjWvUEsddgu8GVJk0VUCMkEeWhW/u0w=";
=======
    sha256 = "+aLs0+nHWglFYAM6CHyrPAALS/7x4vYOtu/M1mKH6hg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  modRoot = "./agent";

<<<<<<< HEAD
  vendorHash = "sha256-lZ7W7YpigcVaLO9HoS5V379nyKHemRh9Z2NjlZbJcPg=";
=======
  vendorSha256 = "sha256-TInS0uTpjTrLuthRn0SOSDh3j0bf+XCP4PVcL19mBiQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.AgentVersion=v${version}" ];

  passthru = {
<<<<<<< HEAD
    updateScript = nix-update-script { };
=======
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

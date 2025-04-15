{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "osc";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "theimpostor";
    repo = "osc";
    tag = "v${version}";
    hash = "sha256-MfEBbYT99tEtlOMmdl3iq2d07KYsN1tu5tDRFW3676g=";
  };

  vendorHash = "sha256-POtQWIjPObsfa3YZ1dLZgedZFUcc4HeTWjU20AucoKc=";

  meta = {
    description = "Command line tool to access the system clipboard from anywhere using the ANSI OSC52 sequence";
    longDescription = ''
      osc provides the commands osc copy, which copies stdin to the system clipboard, and osc paste, which outputs system clipboard contents to stdout.
      System clipboard access includes writing (i.e. copy) and reading (i.e. paste), even while logged into a remote machine via ssh.
    '';
    homepage = "https://github.com/theimpostor/osc";
    changelog = "https://github.com/theimpostor/osc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ harryposner ];
    mainProgram = "osc";
  };
}

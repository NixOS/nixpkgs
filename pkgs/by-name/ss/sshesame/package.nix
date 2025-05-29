{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule rec {
  pname = "sshesame";
  version = "0.0.39";

  src = fetchFromGitHub {
    owner = "jaksi";
    repo = "sshesame";
    rev = "v${version}";
    hash = "sha256-h0qvi90gbWm4LCL3FeipW8BKkbuUt0xGMTjaaeYadnE=";
  };

  vendorHash = "sha256-1v+cNMr2jpLPfxusPsgnFN31DwuNntXuq3sDNpWL0Rg=";

  ldflags = [
    "-s"
    "-w"
  ];

  hardeningEnable = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "pie" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy to set up and use SSH honeypot";
    longDescription = ''
      A fake SSH server that lets anyone in and logs their activity.
      sshesame accepts and logs SSH connections and activity (channels, requests),
      without doing anything on the host (e.g. executing commands, making network requests).
    '';
    homepage = "https://github.com/jaksi/sshesame";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sshesame";
  };
}

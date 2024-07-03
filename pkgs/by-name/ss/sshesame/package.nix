{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "sshesame";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "jaksi";
    repo = "sshesame";
    rev = "v${version}";
    hash = "sha256-D+vygu+Zx/p/UmqOXqx/4zGv6mtCUKTeU5HdBhxdbN4=";
  };

  vendorHash = "sha256-WX3rgv9xz3lisYSjf7xvx4oukDSuxE1yqLl6Sz/iDYc=";

  ldflags = [ "-s" "-w" ];

  hardeningEnable = lib.optionals (!stdenv.isDarwin) [ "pie" ];

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
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "sshesame";
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, nix-update-script
}:

buildGoModule rec {
  pname = "sshesame";
  version = "0.0.38";

  src = fetchFromGitHub {
    owner = "jaksi";
    repo = "sshesame";
    rev = "v${version}";
    hash = "sha256-CSoDUfbYSf+V7jHVqXGhLc6Mrluy+XbZKCs6IA8reIw=";
  };

  vendorHash = "sha256-tfxqr1yDXE+ACCfAtZ0xePpB/xktfwJe/xPU8qAVz54=";

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

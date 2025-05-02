{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "sshesame";
  version = "0.0.27";

  src = fetchFromGitHub {
    owner = "jaksi";
    repo = "sshesame";
    rev = "v${version}";
    hash = "sha256-pDLCOyjvbHM8Cw1AIt7+qTbCmH0tGSmwaTBz5pQ05bc=";
  };

  vendorHash = "sha256-iaINGWpj2gHfwsIOEp5PwlFBohXX591+/FBGyu656qI=";

  ldflags = [ "-s" "-w" ];

  hardeningEnable = [ "pie" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An easy to set up and use SSH honeypot";
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

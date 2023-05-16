{ lib, buildGoModule, fetchFromGitHub, nix-update-script, testers, sptlrx }:

buildGoModule rec {
  pname = "sptlrx";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6GbefTWrhH6RdASmSrugd4xESkwqFVF5qwFmf0JUDTY=";
  };

  vendorHash = "sha256-Ll5jUjpx4165BAE86/z95i4xa8fdKlfxqrUc/gDLqJ0=";
=======
    sha256 = "sha256-UDxmUc902A6+DC254wyvjSzNs95K7QIuDW+24o8VCCc=";
  };

  vendorSha256 = "sha256-t9Mkszzuw7YtBnADsZDjwN2AA6MuQH4+zzDiHe302A4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = sptlrx;
      version = "v${version}"; # needed because testVersion uses grep -Fw
    };
  };

  meta = with lib; {
    description = "Spotify lyrics in your terminal";
    homepage = "https://github.com/raitonoberu/sptlrx";
    changelog = "https://github.com/raitonoberu/sptlrx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}

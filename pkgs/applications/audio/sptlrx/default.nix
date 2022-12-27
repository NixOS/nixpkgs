{ lib, buildGoModule, fetchFromGitHub, nix-update-script, testers, sptlrx }:

buildGoModule rec {
  pname = "sptlrx";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UDxmUc902A6+DC254wyvjSzNs95K7QIuDW+24o8VCCc=";
  };

  vendorSha256 = "sha256-t9Mkszzuw7YtBnADsZDjwN2AA6MuQH4+zzDiHe302A4=";

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

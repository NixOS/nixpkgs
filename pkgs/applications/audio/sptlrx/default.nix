{ lib, buildGoModule, fetchFromGitHub, nix-update-script, testers, sptlrx }:

buildGoModule rec {
  pname = "sptlrx";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6GbefTWrhH6RdASmSrugd4xESkwqFVF5qwFmf0JUDTY=";
  };

  vendorHash = "sha256-Ll5jUjpx4165BAE86/z95i4xa8fdKlfxqrUc/gDLqJ0=";

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

{ lib, buildGoModule, fetchFromGitHub, nix-update-script, testers, sptlrx }:

buildGoModule rec {
  pname = "sptlrx";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b38DACSdnjwPsLMrkt0Ubpqpn/4SDAgrdSlp9iAcxfE=";
  };

  vendorSha256 = "sha256-/fqWnRQBpLNoTwqrFDKqQuv1r9do1voysBhLuj223S0=";

  ldflags = [ "-s" "-w" ];

  passthru = {
    updateScript = nix-update-script { attrPath = pname; };
    tests.version = testers.testVersion {
      package = sptlrx;
      # TODO Wrong version in `0.2.0`. Has been fixed upstream.
      version = "v0.1.0";
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

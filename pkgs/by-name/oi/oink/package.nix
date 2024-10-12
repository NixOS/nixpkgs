{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oink";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "rlado";
    repo = "oink";
    rev = "v${version}";
    hash = "sha256-nA1M+TIj2mWhaftS5y4D2zIs7HAI4eDRjSdmLUifGKg=";
  };

  vendorHash = null;

  postInstall = ''
    mv $out/bin/src $out/bin/oink
  '';

  meta = {
    description = "Dynamic DNS client for Porkbun";
    homepage = "https://github.com/rlado/oink";
    license = lib.licenses.mit;
    mainProgram = "oink";
    maintainers = with lib.maintainers; [ jtbx ];
  };
}

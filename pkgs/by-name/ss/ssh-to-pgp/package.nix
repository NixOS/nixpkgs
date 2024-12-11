{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gnupg,
}:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-EynI4YQ6yjhMIOSoMM7WgLwI//5moFgdhFLX82J+bSA=";
  };

  vendorHash = "sha256-ww1CDDGo2r8h0ePvU8PS2owzE1vLTz2m7Z9thsQle7s=";

  nativeCheckInputs = [ gnupg ];
  checkPhase = ''
    HOME=$TMPDIR go test .
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys to PGP";
    mainProgram = "ssh-to-pgp";
    homepage = "https://github.com/Mic92/ssh-to-pgp";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}

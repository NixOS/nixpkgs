{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gnupg,
}:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-h1/KWkbHpROkMRJ3pMN42/9+thlfY8BtWoOvqt7rxII=";
  };

  vendorHash = "sha256-2FKOonSdsAQPYttABW5xBkmXraqbTRc8ck882fmtlcI=";

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

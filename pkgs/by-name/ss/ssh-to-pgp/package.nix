{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gnupg,
}:

buildGoModule (finalAttrs: {
  pname = "ssh-to-pgp";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = finalAttrs.version;
    sha256 = "sha256-h1/KWkbHpROkMRJ3pMN42/9+thlfY8BtWoOvqt7rxII=";
  };

  vendorHash = "sha256-2FKOonSdsAQPYttABW5xBkmXraqbTRc8ck882fmtlcI=";

  nativeCheckInputs = [ gnupg ];
  checkPhase = ''
    HOME=$TMPDIR go test .
  '';

  doCheck = true;

  meta = {
    description = "Convert ssh private keys to PGP";
    mainProgram = "ssh-to-pgp";
    homepage = "https://github.com/Mic92/ssh-to-pgp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
  };
})

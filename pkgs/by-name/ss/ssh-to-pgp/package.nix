{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gnupg,
}:

buildGoModule rec {
  pname = "ssh-to-pgp";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-pgp";
    rev = version;
    sha256 = "sha256-Pd/bbXwvWHjU2ETKlcODO1F6211JnlK7pU74Mu01UvU=";
  };

  vendorHash = "sha256-69XsFBg7SdvSieQaKUDUESLtAh8cigyt47NQBO3mHpo=";

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

{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-0i3h46lVyCbA4zJdjHM9GyRxZR6IsavpdDG3pdFEGjk=";
  };

  vendorHash = "sha256-4R+44AM0zS6WyKWfg0TH5OxmrC1c4xN0MSBgaZrWPX4=";

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys in ed25519 format to age keys";
    homepage = "https://github.com/Mic92/ssh-to-age";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "ssh-to-age";
  };
}

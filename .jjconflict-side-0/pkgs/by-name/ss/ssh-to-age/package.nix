{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "ssh-to-age";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
    sha256 = "sha256-Y+GC8Zkznjr0pTvYED+uE1v6zIg+tq44F++ZrBytS1E=";
  };

  vendorHash = "sha256-bAawCPfMR4B+mXBHzaTlKs0UYh07F30/epy4qkf2QhM=";

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

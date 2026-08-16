{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "ssh-to-age";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-j+X+kZCOmMdNw8LBDoixl8ToRmDjbmRVe7+IGS/2sMg=";
  };

  vendorHash = "sha256-FveYuYa6C3R50+jdAlU1jorRw/mg482eZ4ZJ8Pu+R0s=";

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  doCheck = true;

  meta = {
    description = "Convert ssh private keys in ed25519 format to age keys";
    homepage = "https://github.com/Mic92/ssh-to-age";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "ssh-to-age";
  };
})

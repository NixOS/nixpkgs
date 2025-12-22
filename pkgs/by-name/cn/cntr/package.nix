{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-4HBOUx9086nn3hRBLA4zuH0Dq+qDZHgo3DivmiEMh3w=";
  };

  cargoHash = "sha256-FBlKxQcQRkz5dYInot2WtZfUSAaX+7qlin+cLf3h8f4=";

  passthru.tests = nixosTests.cntr;

  meta = {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
}

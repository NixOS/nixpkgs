{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
<<<<<<< HEAD
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
=======
    sha256 = "sha256-2tqPxbi8sKoEPq0/zQFsOrStEmQGlU8s81ohTfKeOmE=";
  };

  cargoHash = "sha256-gWQ8seCuUSHuZUoNH9pnBTlzF9S0tHVLStnAiymLLbs=";

  passthru.tests = nixosTests.cntr;

  meta = with lib; {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
}

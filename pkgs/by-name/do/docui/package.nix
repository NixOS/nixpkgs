{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docui";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "docui";
    rev = version;
    hash = "sha256-tHv1caNGiWC9Dc/qR4ij9xGM1lotT0KyrpJpdBsHyks=";
  };

  vendorHash = "sha256-5xQ5MmGpyzVh4gXZAhCY16iVw8zbCMzMA5IOsPdn7b0=";

<<<<<<< HEAD
  meta = {
    description = "TUI Client for Docker";
    homepage = "https://github.com/skanehira/docui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aethelz ];
=======
  meta = with lib; {
    description = "TUI Client for Docker";
    homepage = "https://github.com/skanehira/docui";
    license = licenses.mit;
    maintainers = with maintainers; [ aethelz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "docui";
  };
}

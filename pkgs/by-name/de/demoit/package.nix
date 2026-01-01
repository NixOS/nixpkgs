{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "demoit";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dgageot";
    repo = "demoit";
    rev = "v${version}";
    hash = "sha256-3g0k2Oau0d9tXYDtxHpUKvAQ1FnGhjRP05YVTlmgLhM=";
  };

  vendorHash = null;

  subPackages = [ "." ];

<<<<<<< HEAD
  meta = {
    description = "Live coding demos without Context Switching";
    homepage = "https://github.com/dgageot/demoit";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Live coding demos without Context Switching";
    homepage = "https://github.com/dgageot/demoit";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "demoit";
  };
}

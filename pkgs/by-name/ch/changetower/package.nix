{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "changetower";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Dc4ts";
    repo = "ChangeTower";
    rev = "v${version}";
    hash = "sha256-P20kzsFTR6kVWUD6mt3T3sge/ioIYgeREfy40oxlDBU=";
  };

  vendorHash = "sha256-eA2gReP2PbCPHAQGjC/4CvalfczyCAuNNlS3zOHUT0E=";

<<<<<<< HEAD
  meta = {
    description = "Tools to watch for webppage changes";
    homepage = "https://github.com/Dc4ts/ChangeTower";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Tools to watch for webppage changes";
    homepage = "https://github.com/Dc4ts/ChangeTower";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ChangeTower";
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
<<<<<<< HEAD
  version = "2.22.11";
=======
  version = "2.22.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xCCZUM88z6sSFEo2XQJNx0fTh6KBer7oBSnBEZr3xk0=";
  };

  vendorHash = "sha256-n5ORSfEcXOc2bUDArEzwlTiDo2ILu8aGte3pPOou+6c=";
=======
    hash = "sha256-KQfQ6RDrnO13emfjiQn+zSI+3Zj9hLWhdLZbAmQBdT0=";
  };

  vendorHash = "sha256-kH7bD4CqFgnw5kuPKyQkwGYUuzkQEmuw7T8fxQ46h3o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kalbasit
      nilp0inter
    ];
  };
}

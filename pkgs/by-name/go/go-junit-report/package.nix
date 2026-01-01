{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-junit-report";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jstemmer";
    repo = "go-junit-report";
    rev = "v${version}";
    sha256 = "sha256-s4XVjACmpd10C5k+P3vtcS/aWxI6UkSUPyxzLhD2vRI=";
  };

  vendorHash = "sha256-+KmC7m6xdkWTT/8MkGaW9gqkzeZ6LWL0DXbt+12iTHY=";

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    description = "Convert go test output to junit xml";
    mainProgram = "go-junit-report";
    homepage = "https://github.com/jstemmer/go-junit-report";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cryptix ];
=======
  meta = with lib; {
    description = "Convert go test output to junit xml";
    mainProgram = "go-junit-report";
    homepage = "https://github.com/jstemmer/go-junit-report";
    license = licenses.mit;
    maintainers = with maintainers; [ cryptix ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

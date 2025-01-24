{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "align";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Guitarbum722";
    repo = pname;
    rev = "v${version}";
    sha256 = "17gs3417633z71kc6l5zqg4b3rjhpn2v8qs8rnfrk4nbwzz4nrq3";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/Guitarbum722/align";
    description = "General purpose application and library for aligning text";
    mainProgram = "align";
    maintainers = with maintainers; [ hrhino ];
    license = licenses.mit;
  };
}

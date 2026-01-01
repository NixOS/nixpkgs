{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "pdfannots2json";
  version = "1.0.16";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mgmeyers";
    repo = "pdfannots2json";
    tag = version;
    hash = "sha256-qk4OSws/6SevN/Q0lsyxw+fZkm2uy1WwOYYL7CB7QUk=";
  };

  vendorHash = null;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/mgmeyers/pdfannots2json";
    license = lib.licenses.agpl3Only;
    description = "Tool to convert PDF annotations to JSON";
    mainProgram = "pdfannots2json";
    maintainers = with lib.maintainers; [ _0nyr ];
=======
  meta = with lib; {
    homepage = "https://github.com/mgmeyers/pdfannots2json";
    license = licenses.agpl3Only;
    description = "Tool to convert PDF annotations to JSON";
    mainProgram = "pdfannots2json";
    maintainers = with maintainers; [ _0nyr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

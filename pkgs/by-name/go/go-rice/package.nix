{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-rice";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "GeertJohan";
    repo = "go.rice";
    rev = "v${version}";
    sha256 = "sha256-nJt2t6iTZn8B990SZwEC23pivZke1OKVwTI2GDN6m0o=";
  };

  vendorHash = "sha256-KTT5Ld0Uyyfkhk29KuQuZoGG8UTz1E5Q7fUoSy7iKxM=";

  subPackages = [
    "."
    "rice"
  ];

  meta = with lib; {
    description = "Go package that makes working with resources such as html, js, css, images, templates very easy";
    homepage = "https://github.com/GeertJohan/go.rice";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    mainProgram = "rice";
  };
}

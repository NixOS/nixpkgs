{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pdfannots2json";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "mgmeyers";
    repo = "pdfannots2json";
    tag = finalAttrs.version;
    hash = "sha256-qk4OSws/6SevN/Q0lsyxw+fZkm2uy1WwOYYL7CB7QUk=";
  };

  vendorHash = null;

  meta = {
    homepage = "https://github.com/mgmeyers/pdfannots2json";
    license = lib.licenses.agpl3Only;
    description = "Tool to convert PDF annotations to JSON";
    mainProgram = "pdfannots2json";
    maintainers = with lib.maintainers; [ _0nyr ];
  };
})

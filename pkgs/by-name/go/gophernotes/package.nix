{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gophernotes";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vl0wtVkKfbXHj6OzYeslRmi1FaglzQG9yaZnVnNp2DY=";
  };

  vendorHash = "sha256-ElmO0hzCoNelH53ZtCYXPdR9MGAH4Pl+RlrGZ6GKOpo=";

  meta = {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.costrouc ];
    mainProgram = "gophernotes";
  };
})

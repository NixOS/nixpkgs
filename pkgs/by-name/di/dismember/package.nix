{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dismember";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "dismember";
    tag = "v${version}";
    hash = "sha256-myoBXoi7VqHOLmu/XrvnlfBDlEnXm+0fp8WQec+3EJY=";
  };

  vendorHash = "sha256-xxZQz94sr7aSNhmvFWdRtVnS0yk2KQIkAHjwZeJPBwY=";

  meta = with lib; {
    description = "Tool to scan memory for secrets";
    homepage = "https://github.com/liamg/dismember";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dismember";
  };
}

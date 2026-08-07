{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dismember";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "dismember";
    tag = "v${finalAttrs.version}";
    hash = "sha256-myoBXoi7VqHOLmu/XrvnlfBDlEnXm+0fp8WQec+3EJY=";
  };

  vendorHash = "sha256-xxZQz94sr7aSNhmvFWdRtVnS0yk2KQIkAHjwZeJPBwY=";

  meta = {
    description = "Tool to scan memory for secrets";
    homepage = "https://github.com/liamg/dismember";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dismember";
  };
})

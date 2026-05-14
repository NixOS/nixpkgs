{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "boltbrowser";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "br0xen";
    repo = "boltbrowser";
    tag = finalAttrs.version;
    sha256 = "sha256-3t0U1bSJbo3RJZe+PwaUeuzSt23Gs++WRe/uehfa4cA=";
  };

  vendorHash = "sha256-lLSjAO0sK2zwl+id/e15XWYbLPCa7qK8J6tdvaBMLPs=";

  meta = {
    description = "CLI Browser for BoltDB files";
    homepage = "https://github.com/br0xen/boltbrowser";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "boltbrowser";
  };
})

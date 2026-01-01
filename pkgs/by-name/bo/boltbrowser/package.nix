{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "boltbrowser";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "br0xen";
    repo = "boltbrowser";
    tag = version;
    sha256 = "sha256-3t0U1bSJbo3RJZe+PwaUeuzSt23Gs++WRe/uehfa4cA=";
  };

  vendorHash = "sha256-lLSjAO0sK2zwl+id/e15XWYbLPCa7qK8J6tdvaBMLPs=";

<<<<<<< HEAD
  meta = {
    description = "CLI Browser for BoltDB files";
    homepage = "https://github.com/br0xen/boltbrowser";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "CLI Browser for BoltDB files";
    homepage = "https://github.com/br0xen/boltbrowser";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "boltbrowser";
  };
}

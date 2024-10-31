{
  lib,
  buildGoModule,
  fetchFromGitLab,
  fetchpatch2,
}:

buildGoModule rec {
  pname = "golex";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "cznic";
    repo = "golex";
    rev = "v${version}";
    hash = "sha256-0Z2oE00vGnH2BBNmKAjRhy//fEbT5AQ+CKLIUr+NPwY=";
  };

  patches = [
    # fix a unicode mismatch to make test pass
    (fetchpatch2 {
      url = "https://gitlab.com/cznic/golex/-/commit/a735a3b62b5fb36a715ba4e280270f9ca91c5e59.patch";
      hash = "sha256-Q/Vyh91IwL3ConWpJU0akslkaVhHTkBmrMbmDVU3Txs=";
    })
  ];

  vendorHash = "sha256-Ig4cxZepvmI1EH0j2fuQ33jHOLWfS40UE+A4UHdo8oE=";

  meta = {
    description = "Lex/flex like utility rendering .l formated data to Go source code";
    homepage = "https://pkg.go.dev/modernc.org/golex";
    license = lib.licenses.bsd3;
    mainProgram = "golex";
    maintainers = with lib.maintainers; [ aleksana ];
  };
}

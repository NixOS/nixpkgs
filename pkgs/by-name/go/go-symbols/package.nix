{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "go-symbols";
  version = "0.1.1";

  vendorHash = "sha256-8unWnxTQzPY8tKBtss9qQG+ksWyheKxKRlg65F0vWWU=";

  src = fetchFromGitHub {
    owner = "acroca";
    repo = "go-symbols";
    rev = "v${version}";
    hash = "sha256-P2N4Hqrazu02CWOfAu7/KGlpjzjN65hkyWI1S5nh33s=";
  };

  patches = [
    # Migrate to Go modules
    (fetchpatch {
      url = "https://github.com/acroca/go-symbols/commit/414c2283696b50fc5009055e5bc2590ce45f4400.patch";
      hash = "sha256-9lndJhyN8eaovjQlfSRGP8lC4F+pAXUoR2AvYvhSx2U=";
    })
  ];

  meta = {
    description = "Utility for extracting a JSON representation of the package symbols from a go source tree";
    mainProgram = "go-symbols";
    homepage = "https://github.com/acroca/go-symbols";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      vdemeester
    ];
    license = lib.licenses.mit;
  };
}

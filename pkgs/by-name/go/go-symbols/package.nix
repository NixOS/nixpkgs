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
    sha256 = "0yyzw6clndb2r5j9isyd727njs98zzp057v314vfvknsm8g7hqrz";
  };

  patches = [
    # Migrate to Go modules
    (fetchpatch {
      url = "https://github.com/acroca/go-symbols/commit/414c2283696b50fc5009055e5bc2590ce45f4400.patch";
      hash = "sha256-9lndJhyN8eaovjQlfSRGP8lC4F+pAXUoR2AvYvhSx2U=";
    })
  ];

  meta = {
    description = "A utility for extracting a JSON representation of the package symbols from a go source tree";
    mainProgram = "go-symbols";
    homepage = "https://github.com/acroca/go-symbols";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      vdemeester
    ];
    license = lib.licenses.mit;
  };
}

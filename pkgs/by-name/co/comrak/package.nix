{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-LnsYGRsQvKUIYTgeN3Z9BKga8hHmrHSA/ucH9dNDYPI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YyOJr/Y7Q2yJ21u+wyYeDe9SDmFuKlPVRol3IclOOQU=";

  meta = with lib; {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      figsoda
      kivikakk
    ];
  };
}

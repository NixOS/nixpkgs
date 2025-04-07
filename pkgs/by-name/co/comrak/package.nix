{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    tag = "v${version}";
    sha256 = "sha256-chgg/6BJlCTOWPQ0jnE4l5O/lk0iA4xSwdWURKMF+f8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lP0eGjYZ3AOOH8O4N77QRCNt5Vd2FGfP95vdJN467rE=";

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

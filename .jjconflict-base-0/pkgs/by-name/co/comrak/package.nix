{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-hy/kn8hShwzLHvzp3x1eSGipYRSXjOYCMPHEM1xQEr0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MFSyxoNzPzIP2Yi3lCyEcsAx4DvNmk2Jr75oD/tX9iE=";

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

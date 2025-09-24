{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.41.1";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-jOsbbSCI6upvWsCkpiSEherwVluv7YPLQbxSLEBOQA4=";
  };

  cargoHash = "sha256-0OtFCb5/rdDCtRiGow6t1bpc/H3ZZRMsHhcYG+2IFhw=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      figsoda
      kivikakk
    ];
  };
}

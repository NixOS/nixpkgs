{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = "mdbook-pagetoc";
    rev = "v${version}";
    hash = "sha256-A8J3cKSA//NGIVK3uE43YH3ph9DHGFlg7uOo10j2Kh8=";
  };

  cargoHash = "sha256-e0J3dcBLoDIvmdUxUY/OKivtIHIhRyAw/tpVWV0TgrE=";

  meta = with lib; {
    description = "Table of contents for mdbook (in sidebar)";
    mainProgram = "mdbook-pagetoc";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = licenses.mit;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}

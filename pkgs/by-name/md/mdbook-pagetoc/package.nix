{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = "mdbook-pagetoc";
    rev = "v${version}";
    hash = "sha256-l3CR/ax1i2SJPxIubQUUJ5Hz/8uNl383YeHs8XZ8WGI=";
  };

  cargoHash = "sha256-Ktui+bA1r1M1IfqWwMRAEF4JKEWmLN7Cx3AbRmv6RVc=";

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

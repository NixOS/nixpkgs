{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "commit-formatter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Eliot00";
    repo = "commit-formatter";
    rev = "v${version}";
    sha256 = "sha256-hXpHEtPj6lrYBAzz8ZrhK+L3RBB2K1VIAi81kFlFgxY=";
  };

  cargoHash = "sha256-rqIBDzZghz+fj96im+SNwnLV9jCRjRmh3Wd48z07XH0=";

  meta = with lib; {
    description = "CLI tool to help you write git commit";
    homepage = "https://github.com/Eliot00/commit-formatter";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ elliot ];
    mainProgram = "git-cf";
  };
}

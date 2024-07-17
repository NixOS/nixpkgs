{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "commit-formatter";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Eliot00";
    repo = pname;
    rev = "v${version}";
    sha256 = "EYzhb9jJ4MzHxIbaTb1MxeXUgoxTwcnq5JdxAv2uNcA=";
  };

  cargoSha256 = "AeHQCoP1HOftlOt/Yala3AXocMlwwIXIO2i1AsFSvGQ=";

  meta = with lib; {
    description = "A CLI tool to help you write git commit";
    homepage = "https://github.com/Eliot00/commit-formatter";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ elliot ];
    mainProgram = "git-cf";
  };
}

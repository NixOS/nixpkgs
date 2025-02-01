{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4Ea/YCh0a5xToEmyqpvt8fTtsbL/K0RcQBUitHNCKgo=";
  };

  cargoHash = "sha256-pZ4aHmfiHMvatUY5oTvLtJiIVvknAi3NFVP30rcEmRo=";

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

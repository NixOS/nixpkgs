{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VN8f5r25kfUqekt9q28oMmkzQUE+Ko8DYhRZjpbbDfM=";
  };

  cargoHash = "sha256-Hdjit5dpZXT7ENamUX0ygTy+XAyCkcqq94wAJUPd8DY=";

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

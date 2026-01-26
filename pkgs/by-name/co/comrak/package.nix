{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-OWfNg66ZLorN+PW26v2n695f8vfqT76jO6Bl+M/FNdc=";
  };

  cargoHash = "sha256-d4krWEvupTniVka4f7OPvWbJx6YoT0tfzxr7SU46jME=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kivikakk
    ];
  };
}

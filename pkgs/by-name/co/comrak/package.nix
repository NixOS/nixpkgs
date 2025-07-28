{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-lPO0i6oQtJqcmXDsqhTQV+7a6V04cMcvm2Jn3eWEceg=";
  };

  cargoHash = "sha256-TA8tC/8LfXzoxYJZlVELZirg9Xzr677VugzFwm5NHM4=";

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

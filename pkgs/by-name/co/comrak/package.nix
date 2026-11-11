{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comrak";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cqwvkEuHTTNP5PiWDIhWa8D8MAqIDVN8pWNMEWP3Yzc=";
  };

  cargoHash = "sha256-Bc9c0urg+iAKyjg9d2wwpLgq3EwJn4mJLl8oAB8PZD8=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kivikakk
    ];
  };
})

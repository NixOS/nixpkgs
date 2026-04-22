{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comrak";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MMCA6PfVt9kUvdOKlIBFUxTXEJwNETyxgdPhdXcM/os=";
  };

  cargoHash = "sha256-uHJvkFcKnX3gduTSQokhWwz9ABY94KxIQg7Q7fvyMhk=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${finalAttrs.version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kivikakk
    ];
  };
})

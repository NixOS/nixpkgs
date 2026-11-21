{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comrak";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8mXYkcPdMoLrxL4lTgofqkdI48YDfSfaGe/slVsnfw0=";
  };

  cargoHash = "sha256-GHo75qG6+a15/ue3NCUst7Snv7fd1NQshJ4T4eLSISU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

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

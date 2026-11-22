{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comrak";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-N1VP7KcpLK/KEXoWpE/qUq2S0aPKxGOdoZYSwpFpQhM=";
  };

  cargoHash = "sha256-KhQFBv4RsKjfCNxGenWikNDcrPercNd5y8NAvBnS9LA=";

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

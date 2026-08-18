{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-pagecrypt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Wybxc";
    repo = "mdbook-pagecrypt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JO6keFFTvpyE7Qefstxi1tZuyJcwqF/HD8hf3Mi/y4g=";
  };

  cargoHash = "sha256-+cw/F6JZAwhdUjdhGT3qfvAf8qZ7J4ftHsfRTz6McWE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Encrypt your mdBook-built site with password protection";
    mainProgram = "mdbook-pagecrypt";
    homepage = "https://github.com/Wybxc/mdbook-pagecrypt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jhult ];
  };
})

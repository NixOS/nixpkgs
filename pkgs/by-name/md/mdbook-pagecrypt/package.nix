{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-pagecrypt";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Wybxc";
    repo = "mdbook-pagecrypt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pwEiqLJM4EXqt32j5h7aaJdcdauRtkvxSSu1wbtWr5E=";
  };

  cargoHash = "sha256-muhLJfOh5riSuymmu1NSemM+c+7Y1Ya/YG9TjFQgPkk=";

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

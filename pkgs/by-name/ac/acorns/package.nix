{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "acorns";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "acorns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TqLfEiq4FYrc88aJK047n+pjMNkz7/H9AQZ6wxb1dI0=";
  };

  cargoHash = "sha256-q+XDKVNH1FLggfHlThck3yGDyFL9N7vHlj5cxPCnkdU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Generate an AsciiDoc release notes document from tracking tickets";
    homepage = "https://redhat-documentation.github.io/acorns/";
    downloadPage = "https://github.com/redhat-documentation/acorns";
    changelog = "https://github.com/redhat-documentation/acorns/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "acorns";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "bouncarr";
  version = "0.1.0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "teknostom";
    repo = "bouncarr";
    rev = "fb8eba8f5c69d3611d60e73d7554cf3fc7f5d2ae";
    hash = "sha256-+LwI6gPdoIKp8Nwhjg7Tlo5ckT2UGRizj/XIC0LBCZ8=";
  };

  cargoHash = "sha256-rWkjLV8H8ryrUd+3VOVq90XIyNsRnavCAmw0NYKWpgQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Authentication proxy for the *arr stack using Jellyfin SSO";
    homepage = "https://github.com/teknostom/bouncarr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "bouncarr";
  };
})

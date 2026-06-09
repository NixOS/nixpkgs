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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "teknostom";
    repo = "bouncarr";
    tag = finalAttrs.version;
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

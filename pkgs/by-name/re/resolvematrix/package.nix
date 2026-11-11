{
  lib,
  fetchFromForgejo,
  rustPlatform,
  aws-lc,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resolvematrix";
  version = "1.4.1";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "resolvematrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JdxHy3GNOakm3k1l2l6hr95iwrH/aiWhzgpSoIIYDU8=";
  };

  buildAndTestSubdir = "cli";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-uiW9yd6cm6F/ewT2Nytqu4X4B/KNj3Az4rr2AL417Zg=";
  };

  meta = {
    homepage = "https://forgejo.ellis.link/continuwuation/resolvematrix";
    description = "A tool providing the ability to resolve Matrix server-to-server endpoints from the server name";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ logn ];
    platforms = lib.platforms.all;
    mainProgram = "resolvematrix";
  };
})

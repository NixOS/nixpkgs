{
  lib,
  fetchFromForgejo,
  rustPlatform,
  aws-lc,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resolvematrix";
  version = "1.4.2";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "resolvematrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dySZE0P0IdAvCmVzh3H/LhfhCE8kNxeSRL5G1ydERqk=";
  };

  buildAndTestSubdir = "cli";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-SewOK4bp58P4QW86ayF956nrfGVNJsz6DDQhXnoxVQw=";
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

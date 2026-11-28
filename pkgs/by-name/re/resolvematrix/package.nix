{
  lib,
  fetchFromForgejo,
  rustPlatform,
  aws-lc,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resolvematrix";
  version = "1.5.0";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "resolvematrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k5n7OQh+lQUMap9fvscpRxHLSQFzZ/7aRhqy7JSop7U=";
  };

  buildAndTestSubdir = "cli";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-H2IpJdYp/J/C9GmxPyPlijumjJ0qxONMwJUhKvszI6s=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://forgejo.ellis.link/continuwuation/resolvematrix";
    description = "A tool providing the ability to resolve Matrix server-to-server endpoints from the server name";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ logn ];
    platforms = lib.platforms.all;
    mainProgram = "resolvematrix";
  };
})

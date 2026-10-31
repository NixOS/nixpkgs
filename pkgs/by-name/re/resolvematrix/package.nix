{
  lib,
  fetchFromForgejo,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resolvematrix";
  version = "1.4.0";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.ellis.link";
    owner = "continuwuation";
    repo = "resolvematrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q/qDz50RdwvMBb0tn5sXpeYLNTjGFiQtV1WoDj7n5GI=";
  };

  buildAndTestSubdir = "cli";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-+yvcoVBynJmDcgQCQiCkj9Y1Us0OWvfoMFEdi60tLLs=";
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

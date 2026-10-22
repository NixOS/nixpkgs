{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  nix-update-script,
}:

let
  zig = zig_0_17;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "anyzig";
  version = "2026_10_20";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "marler8997";
    repo = "anyzig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pQbMU7fR5bVT4Tgxq6kR0/uRgW0EpSkyWyZVTUXsHgM=";
  };

  nativeBuildInputs = [ zig ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-UHKvzdYb7akR87WucYdCa/hlfo+KQxV8BSug7BbIkHk=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universal zig executable that lets you run any version of zig";
    homepage = "https://github.com/marler8997/anyzig";
    changelog = "https://github.com/marler8997/anyzig/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "zig";
  };
})

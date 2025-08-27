{
  fetchFromSourcehut,
  lib,
  pkg-config,
  stdenv,
  river-classic,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_15,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "river-bedload";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "river-bedload";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MOZju7mU/AtaSm9CJgb/UqYpCg697tefJC1yvQPK3S8=";
  };

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-h/TwjH546U2Z8LwvB417qq2lR3Ja0nWdVzoLI7Xna6w=";
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_15.hook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display information about river in json in the STDOUT";
    homepage = "https://git.sr.ht/~novakane/river-bedload";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "river-bedload";
    inherit (river-classic.meta) platforms;
  };
})

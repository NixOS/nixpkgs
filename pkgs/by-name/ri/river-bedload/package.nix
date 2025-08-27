{
  _experimental-update-script-combinators,
  fetchFromSourcehut,
  unstableGitUpdater,
  lib,
  pkg-config,
  stdenv,
  river-classic,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_14,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "river-bedload";
  version = "0.1.1-unstable-2025-03-19";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "river-bedload";
    rev = "4a2855ca2669372c346975dd6e1f612ca563b131";
    hash = "sha256-CQH2LQi2ga4YDD2ZYb998ExDJHK4TGHq5h3z94703Dc=";
  };

  zigDeps = zig_0_14.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-EqfWZlTyV0zmw4HVBUmdN039DVz1nzptwBAAKjsJ2IQ=";
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_14.hook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (unstableGitUpdater { tagPrefix = "v"; })
  ];

  meta = {
    description = "Display information about river in json in the STDOUT";
    homepage = "https://git.sr.ht/~novakane/river-bedload";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "river-bedload";
    inherit (river-classic.meta) platforms;
  };
})

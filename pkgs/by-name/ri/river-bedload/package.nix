{
  _experimental-update-script-combinators,
  callPackage,
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

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    zig_0_14.hook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { tagPrefix = "v"; })
    ./update-build-zig-zon.sh
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

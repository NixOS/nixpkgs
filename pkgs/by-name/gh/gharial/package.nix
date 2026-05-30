{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gharial";
  version = "0.2.1";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "gusahlg";
    repo = "gharial";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o5r8nK95FE5lBMLZfqziEE7JGOAO0HQfxFcybMWee9s=";
  };

  cargoHash = "sha256-Fqhgdqs7xXmd6Bpg7kYLWLiu+Yn4JTbMtJo4iLLFcIs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
  ];

  meta = {
    description = "Minimal external window manager for the river Wayland compositor";
    homepage = "https://github.com/gusahlg/gharial";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [ gusahlg ];
    mainProgram = "gharial";
    platforms = lib.platforms.linux;
  };
})

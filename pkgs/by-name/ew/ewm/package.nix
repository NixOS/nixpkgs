{
  fetchFromGitea,
  glib,
  lib,
  libgbm,
  libinput,
  libxkbcommon,
  nix-update-script,
  pkg-config,
  rustPlatform,
  seatd,
  udev,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ewm";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ezemtsov";
    repo = "ewm";
    rev = "43f6b5ec82b336aef1acf0f78a016ba909a62b4d";
    hash = "sha256-QBT0N9ozw5RkJxp8H23p4hoJSP19IQoR+85WC8rTcyI=";
  };

  cargoHash = "sha256-w34yg6xjG1nBUK2UZBJ+lCqqluCRgDTnoUgbtNLtd4Y=";

  sourceRoot = "source/compositor";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    libgbm
    libinput
    libxkbcommon
    seatd
    udev
    wayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Emacs Wayland Manager";
    longDescription = ''
      EWM is a Wayland compositor that runs inside Emacs.  Wayland
      applications appear as Emacs buffers, letting you switch between
      code and apps with `C-x b`, organize windows with your familiar
      Emacs commands, and keep everything responsive even when Emacs
      is busy evaluating.

      The compositor runs as a separate thread within Emacs (via a
      dynamic module), so applications never freeze waiting for Elisp
      evaluation.

      ```
      ┌─ Emacs Process ────────────────────────────────────────────┐
      │  Main Thread: Elisp execution                              │
      │       ↑↓ shared memory, mutex-protected                    │
      │  Compositor Thread: Smithay (Rust dynamic module)          │
      │       ↑↓                                                   │
      │  Render Thread: DRM/GPU                                    │
      └────────────────────────────────────────────────────────────┘
      ```
    '';
    homepage = "https://codeberg.org/ezemtsov/ewm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ewm";
    platforms = lib.platforms.all;
  };
})

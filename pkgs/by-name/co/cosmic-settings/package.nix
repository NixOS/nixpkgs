{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  just,
  libcosmicAppHook,
  pkg-config,
  expat,
  libinput,
  fontconfig,
  freetype,
  isocodes,
  pipewire,
  pulseaudio,
  udev,
  cosmic-randr,
  xkeyboard_config,
  nix-update-script,
  nixosTests,
}:
let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-settings";
  version = "1.1.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-LfhFza0G85+fIuACMdwV50Okh5/46z8tLoJ9IvLqTgw=";
  };

  cargoPatches = [
    # A different reference to the `libcosmic` crate was added
    # Remove this patch once upstream fixes their lockfile.
    ./dedup-libcosmic.patch
  ];

  cargoHash = "sha256-rYjizOCcLJ4aq3UB5xEwWq5+KvrSi5PCUTIwUM/wegM=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    just
    libcosmicAppHook'
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libinput
    pipewire
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ cosmic-randr ]}
      --prefix XDG_DATA_DIRS : ${lib.makeSearchPathOutput "bin" "share" [ isocodes ]}
      --set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml
      --set-default X11_BASE_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/extra.xml
    )
  '';

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    description = "Settings for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-settings";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-settings";
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})

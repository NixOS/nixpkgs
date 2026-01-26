{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
  libxkbcommon,
  libGL,
  wayland,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  makeWrapper,
  displayServer ? "x11",
  nixosTests,
  nix-update-script,
}:

assert lib.assertOneOf "displayServer" displayServer [
  "x11"
  "wayland"
];

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringboard" + lib.optionalString (displayServer == "wayland") "-wayland";

  # release version needs nightly, so we use a custom tree, see:
  # https://github.com/SUPERCILEX/clipboard-history/issues/22#issuecomment-3676256971
  version = "0.14.0-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "clipboard-history";
    rev = "cb2e94add2388a68a8f015b77f9b082b1658b3b7";
    hash = "sha256-r2632XJ/2Er1TuHCDNm6uItvdhqJ87i9p+h9M2MwKwk=";
  };

  cargoHash = "sha256-c5Zdvz2xHsGh4VnOED2JiitNWwNTSkygaMFHPPLANqw=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libxkbcommon
    libGL
  ]
  ++ lib.optionals (displayServer == "x11") [
    libxcursor
    libxrandr
    libxi
    libx11
  ]
  ++ lib.optionals (displayServer == "wayland") [
    wayland
  ];

  buildPhase = ''
    runHook preBuild

    local flagsArray=("-j $NIX_BUILD_CORES --target ${stdenv.hostPlatform.rust.rustcTarget} --offline --release");
    concatTo flagsArray cargoBuildFlags;

    echo "Building package: clipboard-history-server"
    cargo build $flagsArray --package clipboard-history-server --no-default-features --features systemd
    ${lib.optionalString (displayServer == "x11") ''
      echo "Building package: clipboard-history-x11"
      cargo build $flagsArray --package clipboard-history-x11 --no-default-features
    ''}
    ${lib.optionalString (displayServer == "wayland") ''
      echo "Building package: clipboard-history-wayland"
      cargo build $flagsArray --package clipboard-history-wayland --no-default-features
    ''}
    echo "Building package: clipboard-history"
    cargo build $flagsArray --package clipboard-history
    echo "Building package: clipboard-history-tui"
    cargo build $flagsArray --package clipboard-history-tui
    echo "Building package: clipboard-history-egui"
    cargo build $flagsArray --package clipboard-history-egui --no-default-features --features ${displayServer}

    runHook postBuild
  '';

  # check needs nightly, see:
  # https://github.com/SUPERCILEX/clipboard-history/issues/22#issuecomment-3322330559
  doCheck = false;

  postInstall = ''
    # Wrap the program in a script that sets the LD_LIBRARY_PATH environment variable
    # so that it can find the shared libraries it depends on. This is currently a
    # requirement for running Rust programs that depend on `egui` within a Nix environment.
    # https://github.com/emilk/egui/issues/2486
    wrapProgram  $out/bin/ringboard-egui --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    install -m 444 -D egui/ringboard-egui.desktop $out/share/applications/ringboard-egui.desktop
    install -Dm644 logo.jpeg $out/share/icons/hicolor/1024x1024/ringboard.jpeg
    # Initializing a GUI can be quite slow, so GUI clients make their windows invisible when closed rather than completely quitting.
    # To reopen the window, a special file can be deleted which wakes the GUI via inotify.
    # If, instead, a new instance of the GUI is opened, this special file is used to first check for a previously running instance of the GUI and kill it if it exists.
    # https://alexsaveau.dev/blog/projects/performance/clipboard/ringboard/ringboard#gui-startup-latency-and-long-lived-client-windows
    sed -i "s|Exec=ringboard-egui|Exec=$out/bin/ringboard-egui toggle|g" $out/share/applications/ringboard-egui.desktop
    sed -i "s|Icon=ringboard|Icon=$out/share/icons/hicolor/1024x1024/ringboard.jpeg|g" $out/share/applications/ringboard-egui.desktop
  '';

  passthru = {
    tests.nixos = nixosTests.ringboard;
    updateScript = nix-update-script { extraArgs = [ "--version=branch=stable" ]; };
  };

  meta = {
    description = "Fast, efficient, and composable clipboard manager for Linux";
    homepage = "https://github.com/SUPERCILEX/clipboard-history";
    changelog = "https://github.com/SUPERCILEX/clipboard-history/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})

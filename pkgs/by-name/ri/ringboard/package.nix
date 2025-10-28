{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
  libxkbcommon,
  libGL,
  wayland,
  xorg,
  makeWrapper,
  displayServer ? "x11",
  nixosTests,
}:

assert lib.assertOneOf "displayServer" displayServer [
  "x11"
  "wayland"
];

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringboard" + lib.optionalString (displayServer == "wayland") "-wayland";

  # release version needs nightly, so we use a custom tree, see:
  # https://github.com/SUPERCILEX/clipboard-history/issues/22#issuecomment-3322075172
  version = "0.12.2-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "clipboard-history";
    rev = "228a39dd8a9aece0bb06f68ad44906b297270628";
    hash = "sha256-qA7wwvWnnZHN9edkmubEo37F+peU0LQGo/Zl8FpywuE=";
  };

  cargoHash = "sha256-MFfuUu/hpb6Uaqe21bvXNKRyJazAL5m+Vw/vAeeDYEk=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libxkbcommon
    libGL
  ]
  ++ lib.optionals (displayServer == "x11") [
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
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
    sed -i "s|Exec=ringboard-egui|Exec=$(echo /bin/sh -c \"ps -p \`cat /tmp/.ringboard/\$USER.egui-sleep 2\> /dev/null\` \> /dev/null 2\>\\\&1 \\\&\\\& exec rm -f /tmp/.ringboard/\$USER.egui-sleep \\\|\\\| exec $out/bin/ringboard-egui\")|g" $out/share/applications/ringboard-egui.desktop
    sed -i "s|Icon=ringboard|Icon=$out/share/icons/hicolor/1024x1024/ringboard.jpeg|g" $out/share/applications/ringboard-egui.desktop
  '';

  passthru.tests.nixos = nixosTests.ringboard;

  meta = {
    description = "Fast, efficient, and composable clipboard manager for Linux";
    homepage = "https://github.com/SUPERCILEX/clipboard-history";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})

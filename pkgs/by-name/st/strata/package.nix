{
  bubblewrap,
  cairo,
  coreutils,
  dbus,
  dejavu_fonts,
  desktop-file-utils,
  fetchFromGitHub,
  ffmpeg-headless,
  ffmpegthumbnailer,
  fontconfig,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk4,
  gtksourceview5,
  imagemagick,
  lib,
  librsvg,
  makeFontsConf,
  pkg-config,
  poppler,
  procps,
  python3,
  rustPlatform,
  shared-mime-info,
  squashfs-tools,
  stdenv,
  tzdata,
  util-linux,
  wrapGAppsHook4,
  xdg-utils,
  xvfb-run,
  enableRar ? false,
}:

let
  runtimeTools = [
    bubblewrap
    coreutils
    desktop-file-utils
    ffmpeg-headless
    ffmpegthumbnailer
    (lib.getBin fontconfig)
    (lib.getBin glib)
    imagemagick
    squashfs-tools
    util-linux
    xdg-utils
  ];

  gstPlugins = with gst_all_1; [
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "strata";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "lgse";
    repo = "strata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSTEgtfDYYGxXef1J22NMGpmgjObg3T6APZqfSyfNPY=";
  };

  cargoHash = "sha256-0nMfswOfyXiwIWF0Xne61jGwPdU/gMo6Wt6JGZEfrJw=";

  # Nix adaptations to https://github.com/lgse/strata/tree/v0.21.0.
  # These have not been submitted upstream; remove them as upstream adopts them.
  patches = [
    # Validate the store permissions and retain the GApps wrapper during setup.
    ./desktop.patch
    # GStreamer plugin discovery must survive the sandbox's clearenv.
    ./sandbox.patch
    # Trusted helper lookup otherwise only searches fixed FHS directories.
    ./trusted-helper-path.patch
    # Nix installs are package-managed, but must not use the AUR updater.
    ./nix-update-source.patch
    # Normalize only the test namespace's unmapped root owner, not production.
    ./test-sandbox-root.patch
    # Removing a recent app must leave a compatible app to open the chooser.
    ./test-open-with-fixture.patch
  ];

  postPatch = ''
    substituteInPlace src/sandbox/tests.rs \
      --replace-fail /bin/cat ${lib.getBin coreutils}/bin/cat
  '';

  nativeBuildInputs = [
    glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    fontconfig
    gdk-pixbuf
    gtk4
    gtksourceview5
    librsvg
    poppler
  ]
  ++ gstPlugins;

  nativeCheckInputs = [
    dbus
    dejavu_fonts
    ffmpeg-headless
    imagemagick
    procps
    python3
    xvfb-run
  ];

  # Upstream makes embedded non-free UnRAR optional; keep the default package free.
  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional enableRar "rar";

  # Upstream tests use the debug profile; release LTO is only needed for the app.
  checkType = "debug";
  cargoTestFlags = [ "--all-targets" ];

  dontUseCargoParallelTests = true;

  preCheck = ''
    unset DISPLAY WAYLAND_DISPLAY
    export HOME="$TMPDIR/strata-home"
    export XDG_CACHE_HOME="$TMPDIR/strata-cache"
    export XDG_CONFIG_HOME="$TMPDIR/strata-config"
    export XDG_DATA_HOME="$TMPDIR/strata-data"
    export XDG_STATE_HOME="$TMPDIR/strata-state"
    export XDG_RUNTIME_DIR="$TMPDIR/strata-runtime"
    install -d -m700 \
      "$HOME" \
      "$XDG_CACHE_HOME" \
      "$XDG_CONFIG_HOME" \
      "$XDG_DATA_HOME" \
      "$XDG_STATE_HOME" \
      "$XDG_RUNTIME_DIR"
    export GDK_BACKEND=x11
    export GSK_RENDERER=cairo
    export GTK_A11Y=none
    export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH:${shared-mime-info}/share"
    export TZDIR=${tzdata}/share/zoneinfo
    # SVG text regression tests need actual fonts in the isolated build.
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ dejavu_fonts ]; }}
    export NO_AT_BRIDGE=1
    export STRATA_REQUIRE_GTK_TESTS=1
    export STRATA_REQUIRE_DEVICE_TESTS=1
  '';

  checkPhase = ''
    # Keep cargoCheckHook's feature/subdirectory/cross-environment handling.
    # Its `env ... cargo test` invocation resolves this temporary launcher.
    cargoExecutable="$(command -v cargo)"
    cargoTestRunner="$TMPDIR/strata-test-runner"
    mkdir -p "$cargoTestRunner"
    cat > "$cargoTestRunner/cargo" <<EOF
    #!${stdenv.shell}
    exec ${lib.getExe' xvfb-run "xvfb-run"} -s '-screen 0 2560x1600x24' \
      ${lib.getExe' dbus "dbus-run-session"} --config-file=${dbus}/share/dbus-1/session.conf \
      "$cargoExecutable" "\$@"
    EOF
    chmod +x "$cargoTestRunner/cargo"
    PATH="$cargoTestRunner:$PATH" cargoCheckHook
  '';

  env = {
    CARGO_PROFILE_TEST_DEBUG = "0";
    STRATA_BUILD_KIND = "stable";
    STRATA_BUILD_COMMIT = "870fec8e022ff8d29a5a5c1bf1174698bc0b6b09";
    STRATA_RELEASE_TAG = "v${finalAttrs.version}";
    STRATA_SANDBOX_GDK_PIXBUF_MODULE_FILE = "${lib.getOutput "out" librsvg}/${gdk-pixbuf.binaryDir}/loaders.cache";
    STRATA_SANDBOX_GST_PLUGIN_PATH = lib.makeSearchPath "lib/gstreamer-1.0" (
      map (lib.getOutput "out") gstPlugins
    );
    STRATA_SANDBOX_PATH = lib.makeBinPath runtimeTools;
    STRATA_SANDBOX_ROOT = "/nix/store";
    STRATA_SANDBOX_PRLIMIT = "${lib.getBin util-linux}/bin/prlimit";
    STRATA_TRUSTED_COMMAND_PATH = lib.makeBinPath runtimeTools;
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath runtimeTools}
      --prefix XDG_DATA_DIRS : ${shared-mime-info}/share
    )
  '';

  postInstall = ''
    install -Dm644 data/io.github.lgse.Strata.desktop \
      "$out/share/applications/io.github.lgse.Strata.desktop"
    substituteInPlace "$out/share/applications/io.github.lgse.Strata.desktop" \
      --replace-fail 'Exec=strata %U' "Exec=$out/bin/strata %U"
    install -Dm644 data/icons/scalable/apps/io.github.lgse.Strata.svg \
      "$out/share/icons/hicolor/scalable/apps/io.github.lgse.Strata.svg"

    install -d "$out/share/strata"
    cat > "$out/share/strata/install-source.toml" <<'EOF'
    manager = "Nix"
    package = "strata"
    EOF

    install -d "$out/share/licenses/strata"
    install -m644 LICENSE THIRD_PARTY_LICENSES.md data/licenses/*.txt \
      "$out/share/licenses/strata/"
  '';

  meta = {
    changelog = "https://github.com/lgse/strata/releases/tag/v${finalAttrs.version}";
    description = "Fast, keyboard-first file manager for Linux";
    homepage = "https://stratafiles.io/";
    license = [ lib.licenses.mit ] ++ lib.optional enableRar lib.licenses.unfreeRedistributable;
    mainProgram = "strata";
    maintainers = [ lib.maintainers.Shangshui0302 ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})

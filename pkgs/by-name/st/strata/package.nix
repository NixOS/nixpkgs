{
  bubblewrap,
  cairo,
  coreutils,
  coreutils-prefixed,
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
  gnutar,
  imagemagick,
  lib,
  libraw,
  librsvg,
  makeFontsConf,
  nix-update-script,
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
  xdg-terminal-exec,
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
    (lib.getBin libraw)
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
  __structuredAttrs = true;

  pname = "strata";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lgse";
    repo = "strata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFNsFCnkeZs0VwmYRyu+6Jh8XxJzv+agUlP70Fdxa5Q=";
  };

  cargoHash = "sha256-vuhHierqb4WsMdg890NpkaztYnfsnck2FxMz5cPMwCQ=";

  # Nix adaptations to https://github.com/lgse/strata/tree/v1.0.0.
  # These have not been submitted upstream; remove them as upstream adopts them.
  patches = [
    # Validate the store permissions and retain the GApps wrapper during setup.
    ./desktop.patch
    # Trusted helper lookup otherwise only searches fixed FHS directories.
    ./trusted-helper-path.patch
    # Nix installs are package-managed, but must not use the AUR updater.
    ./nix-update-source.patch
    # Normalize only the test namespace's unmapped root owner, not production.
    ./test-sandbox-root.patch
    # Removing a recent app must leave a compatible app to open the chooser.
    ./test-open-with-fixture.patch
    # The archive fixture needs a store-provided tar, not trusted runtime lookup.
    ./test-release-tar.patch
    # Keep permission/time checks on filesystems without user xattr support.
    ./test-xattr-capability.patch
  ];

  postPatch = ''
    substituteInPlace src/sandbox/tests.rs \
      --replace-fail /bin/cat ${lib.getBin coreutils}/bin/cat
    # Store files have an unmapped owner inside the build namespace. Providers
    # require a root- or user-owned executable, so use a private fixture copy.
    install -m555 ${lib.getExe python3} "$TMPDIR/strata-test-python3"
    substituteInPlace src/services/file_providers/tests.rs src/ui/file_providers/tests.rs \
      --replace-fail /usr/bin/python3 "$TMPDIR/strata-test-python3"
    # This ELF is copied and renamed; gtrue is standalone, not multicall.
    substituteInPlace src/services/update_install/manifest/tests.rs \
      src/services/update_install/review_tests.rs \
      --replace-fail /bin/true ${lib.getExe' coreutils-prefixed "gtrue"}
    substituteInPlace src/services/update_install/archive/tests.rs \
      --replace-fail @STRATA_TEST_TAR@ ${lib.getExe gnutar}
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
    coreutils-prefixed
    dbus
    dejavu_fonts
    ffmpeg-headless
    gnutar
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
    # Keep the resolved release commit in sync when updating the version.
    STRATA_BUILD_COMMIT = "0a086aa3bdb251842a1e8413e2a6b35970d0b409";
    STRATA_RELEASE_TAG = "v${finalAttrs.version}";
    STRATA_SANDBOX_GDK_PIXBUF_MODULE_FILE = "${lib.getOutput "out" librsvg}/${gdk-pixbuf.binaryDir}/loaders.cache";
    STRATA_SANDBOX_PATH = lib.makeBinPath runtimeTools;
    STRATA_SANDBOX_ROOT = "/nix/store";
    STRATA_SANDBOX_PRLIMIT = "${lib.getBin util-linux}/bin/prlimit";
    STRATA_TRUSTED_COMMAND_PATH = lib.makeBinPath runtimeTools;
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath runtimeTools}
      # Terminal selection is not a preview sandbox or trusted helper.
      --prefix PATH : ${lib.makeBinPath [ xdg-terminal-exec ]}
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

    # FileManager1 is a shared bus name: retain an opt-in template only.
    install -Dm644 data/io.github.lgse.Strata.FileManager1.service \
      "$out/share/strata/io.github.lgse.Strata.FileManager1.service"
    substituteInPlace "$out/share/strata/io.github.lgse.Strata.FileManager1.service" \
      --replace-fail /usr/bin/strata "$out/bin/strata"

    install -Dm644 data/portal/strata.portal \
      "$out/share/xdg-desktop-portal/portals/strata.portal"
    install -Dm644 data/portal/org.freedesktop.impl.portal.desktop.strata.service.in \
      "$out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.strata.service"
    substituteInPlace "$out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.strata.service" \
      --replace-fail @STRATA_EXECUTABLE@ "$out/bin/strata"

    install -d "$out/share/strata"
    cat > "$out/share/strata/install-source.toml" <<'EOF'
    manager = "Nix"
    package = "strata"
    EOF

    install -d "$out/share/licenses/strata"
    install -m644 LICENSE THIRD_PARTY_LICENSES.md data/licenses/*.txt \
      "$out/share/licenses/strata/"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # installCheckPhase runs after fixup, so both wrapper and binary must exist.
    test -x "$out/bin/strata"
    test -x "$out/bin/.strata-wrapped"
    test -x "${lib.getBin libraw}/bin/simple_dcraw"
    test -x "${lib.getBin libraw}/bin/raw-identify"
    test -x "${lib.getBin xdg-terminal-exec}/bin/xdg-terminal-exec"
    grep -Fx 'Name=org.freedesktop.FileManager1' \
      "$out/share/strata/io.github.lgse.Strata.FileManager1.service"
    grep -Fx "Exec=$out/bin/strata --gapplication-service" \
      "$out/share/strata/io.github.lgse.Strata.FileManager1.service"
    grep -Fx "Exec=$out/bin/strata --portal" \
      "$out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.strata.service"
    grep -Fx 'Name=org.freedesktop.impl.portal.desktop.strata' \
      "$out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.strata.service"
    if grep -RE '(/usr/bin/strata|@STRATA_EXECUTABLE@|\.strata-wrapped)' \
      "$out/share/dbus-1/services" \
      "$out/share/strata/io.github.lgse.Strata.FileManager1.service"; then
      echo "Unsubstituted or unwrapped D-Bus activation executable" >&2
      exit 1
    fi
    if grep -RE '^Name=org\.freedesktop\.FileManager1$' "$out/share/dbus-1/services"; then
      echo "FileManager1 must remain opt-in" >&2
      exit 1
    fi
    cmp data/portal/strata.portal \
      "$out/share/xdg-desktop-portal/portals/strata.portal"

    runHook postInstallCheck
  '';

  # nix-update does not refresh STRATA_BUILD_COMMIT; update it to the release
  # commit and review all downstream patches before accepting a version bump.
  passthru.updateScript = nix-update-script { };

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

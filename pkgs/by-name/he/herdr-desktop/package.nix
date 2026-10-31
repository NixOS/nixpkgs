{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  zig_0_16,
  pkg-config,
  clang,
  makeDesktopItem,
  copyDesktopItems,
  fontconfig,
  freetype,
  libxcb,
  libxkbcommon,
  libGL,
  wayland,
  vulkan-loader,
  mesa,
  writableTmpDirAsHomeHook,
  xdg-utils,
  herdr-core,
  versionCheckHook,
  nix-update-script,
}:
let
  # wgpu (Vulkan, with OpenGL as fallback) and the Wayland backend load these
  # with dlopen.
  dlopenLibs = [
    libGL
    vulkan-loader
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr-desktop";
  version = "0.1.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr-app";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-XXAcJWwaaec/E941NkGAiCWgeHyT5jpYKcfz+8mbkvI=";
  };

  cargoHash = "sha256-NOLcdtc9zLojjkEwGbjiTGTxDhX9w42hWtNrrE3kID4=";

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/ghostty";
    fetchAll = true;
    hash = "sha256-G9xbZ/pyQTDIfzG0h++i70a45zpwyYpZMBZfAnoOQw0=";
  };

  nativeBuildInputs = [
    pkg-config
    # ghostty-sys runs bindgen with clang's builtin headers when clang is on
    # PATH; otherwise it uses Zig's, and bindgen then finds no stdint.h.
    clang
    rustPlatform.bindgenHook
    zig_0_16
    copyDesktopItems
  ];

  buildInputs = [
    fontconfig
    freetype
    libxcb
    libxkbcommon
  ];

  # Cargo drives Zig through the ghostty-sys build script.
  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  postPatch = ''
    # The app opens links and files with xdg-open, and looks for hc on PATH,
    # in the user's login shell and in the usual install places. This
    # herdr-core comes last, so a core the user installed wins.
    substituteInPlace src/links.rs \
      --replace-fail '"xdg-open"' '"${lib.getExe' xdg-utils "xdg-open"}"'
    substituteInPlace vendor/gpui-pre-linux/src/linux/platform.rs \
      --replace-fail 'new_std_command("xdg-open")' 'new_std_command("${lib.getExe' xdg-utils "xdg-open"}")'
    substituteInPlace src/core_bin.rs \
      --replace-fail 'PathBuf::from("/run/current-system/sw/bin"),' \
        'PathBuf::from("/run/current-system/sw/bin"), PathBuf::from("${herdr-core}/bin"),'

    # Settings tells a Nix build to update with git; drop this once
    # https://github.com/herdrdev/herdr-app/issues/136 is fixed.
    substituteInPlace defaults/frame/settings/main.js \
      --replace-fail '"A build from source: it updates with git, not here."' \
        '"Managed by nix: update it there."'

    # The tests use /var/tmp, which the sandbox lacks.
    for f in src/{mod_files.rs,mods.rs,mods/lifecycle_tests.rs,mods/render_tests.rs,update_notes.rs}; do
      substituteInPlace "$f" --replace-fail /var/tmp "$TMPDIR"
    done
  '';

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  # Some tests run programs in $HOME.
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = [
    # Reads element bounds that only debug builds record.
    "--skip=window::tests::fitted_popups_use_their_rendered_size_at_the_window_edge"
    # Races a thread against GPUI's test scheduler and fails now and then.
    "--skip=mods::lifecycle_tests::close_starts_native_work_before_releasing_the_copy"
  ];

  # The render and pixel tests draw real frames, on Mesa's software Vulkan
  # driver; the test binaries don't get the RUNPATH entries from postFixup.
  preCheck = ''
    export VK_DRIVER_FILES=${mesa}/share/vulkan/icd.d/lvp_icd.${stdenv.hostPlatform.parsed.cpu.name}.json
    export LD_LIBRARY_PATH=${lib.makeLibraryPath dlopenLibs}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "herdr-app";
      desktopName = "Herdr";
      comment = "Terminals and coding agents that keep running";
      exec = "herdr-app";
      icon = "herdr-app";
      categories = [ "Development" ];
      startupWMClass = "herdr-app";
    })
  ];

  postInstall = ''
    install -Dm644 assets/icons/herdr-ui-icon-clean.svg \
      $out/share/icons/hicolor/scalable/apps/herdr-app.svg
    install -Dm644 LICENSE THIRD-PARTY-NOTICES -t $out/share/doc/herdr-desktop
  '';

  # A RUNPATH entry rather than LD_LIBRARY_PATH: the app starts herdr-core,
  # which passes its environment on to every terminal. This runs after fixup,
  # which drops RUNPATH entries the binary doesn't link against.
  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath dlopenLibs} $out/bin/herdr-app
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Desktop app for terminals and coding agents";
    homepage = "https://herdr.dev";
    changelog = "https://github.com/herdrdev/herdr-app/blob/v${finalAttrs.version}/CHANGELOG.md";
    # The binary also includes libghostty-vt, QuickJS, fonts and icons under
    # other free licenses; see share/doc/herdr-desktop/THIRD-PARTY-NOTICES.
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tophcodes ];
    mainProgram = "herdr-app";
    platforms = lib.platforms.linux;
  };
})

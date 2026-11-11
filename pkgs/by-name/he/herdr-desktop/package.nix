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
  cctools,
  fontconfig,
  freetype,
  libxcb,
  libxkbcommon,
  zstd,
  libGL,
  wayland,
  vulkan-loader,
  mesa,
  makeFontsConf,
  dejavu_fonts,
  bash,
  coreutils,
  curl,
  git,
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
  version = "0.1.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr-app";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-vM25epPf+4Y+gUj/2BTQ6fpOIBI7T5UddFdlMAr6X0o=";
  };

  cargoHash = "sha256-7bz9iEMvf2o2I0SsnXaZ0135PlMm73DrJ9ZhSqAjcKY=";

  # zig.fetchDeps fails in the Darwin sandbox with CertificateBundleLoadFailure:
  # Zig reads its root certificates from the system keychains, which the
  # sandbox hides. The output is the same on every platform, so Darwin builds
  # take it from the cache; without one, build it with `--option sandbox false`.
  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/ghostty";
    fetchAll = true;
    hash = "sha256-G9xbZ/pyQTDIfzG0h++i70a45zpwyYpZMBZfAnoOQw0=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # ghostty-sys runs bindgen with clang's builtin headers when clang is on
    # PATH; otherwise it uses Zig's, and bindgen then finds no stdint.h.
    clang
    copyDesktopItems
  ]
  # Ghostty combines its static archives with Apple's `libtool -static`.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    freetype
    libxcb
    libxkbcommon
  ];

  env.ZIG = lib.getExe zig_0_16;

  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # Bundled Zig runtimes cause overlapping unwind frames when linked with
      # Rust. Darwin keeps them: Ghostty's libsystem_override.sh extracts
      # compiler_rt.o from the archive.
      substituteInPlace vendor/ghostty/src/build/GhosttyLibVt.zig \
        --replace-fail 'lib.bundle_compiler_rt = true;' 'lib.bundle_compiler_rt = false;' \
        --replace-fail 'lib.bundle_ubsan_rt = true;' 'lib.bundle_ubsan_rt = false;'

      # On Linux the app opens links and files with xdg-open.
      substituteInPlace src/links.rs \
        --replace-fail '"xdg-open"' '"${lib.getExe' xdg-utils "xdg-open"}"'
      substituteInPlace vendor/gpui-pre-linux/src/linux/platform.rs \
        --replace-fail 'new_std_command("xdg-open")' 'new_std_command("${lib.getExe' xdg-utils "xdg-open"}")'

      # Outside macOS this check only exists for a test, which calls
      # /bin/test; the sandbox lacks it.
      substituteInPlace src/core_bin.rs \
        --replace-fail 'Command::new("/bin/test")' 'Command::new("${lib.getExe' coreutils "test"}")'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Ghostty's build calls these by absolute path, which the sandbox lacks.
      substituteInPlace vendor/ghostty/pkg/apple-sdk/native_link.zig \
        --replace-fail '"/usr/bin/xcrun"' '"xcrun"'
      substituteInPlace vendor/ghostty/src/build/GhosttyLibVt.zig \
        --replace-fail '"/bin/ln"' '"ln"'
      substituteInPlace vendor/ghostty/src/build/LibtoolStep.zig \
        --replace-fail '/bin/cp ' 'cp ' \
        --replace-fail '/usr/bin/ranlib ' 'ranlib '
    ''
    + ''
      # The app looks for hc on PATH, then in a list of usual install places.
      # Add the herdr-core package to that list, after the system profile.
      substituteInPlace src/core_bin.rs \
        --replace-fail 'PathBuf::from("/run/current-system/sw/bin"),' \
          'PathBuf::from("/run/current-system/sw/bin"), PathBuf::from("${herdr-core}/bin"),'

      # Settings tells a Nix build to update with git; drop this once
      # https://github.com/herdrdev/herdr-app/issues/136 is fixed.
      substituteInPlace defaults/frame/settings/main.js \
        --replace-fail '"A build from source: it updates with git, not here."' \
          '"Managed by nix: update it there."'

      # The tests use /var/tmp, which the sandbox lacks.
      for f in src/{mod_files.rs,mods.rs,mods/lifecycle_tests.rs,mods/render_tests.rs,update_notes.rs,window.rs}; do
        substituteInPlace "$f" --replace-fail /var/tmp "$TMPDIR"
      done

      # The remote shell tests start /bin/bash, which the sandbox lacks.
      substituteInPlace src/remote_shell.rs \
        --replace-fail '"/bin/bash"' '"${lib.getExe bash}"'
    '';

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -rL ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  # The render tests need Metal, which the sandbox does not provide.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    # An updater test fetches from a local server with curl.
    curl
    # The folder watcher tests set up repositories with git.
    git
    # Some tests run programs in $HOME.
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Read element bounds that only debug builds record.
    "--skip=window::tests::fitted_popups_use_their_rendered_size_at_the_window_edge"
    "--skip=terminal::tests::each_terminal_keeps_its_find_bar_inside_its_own_pane"
    "--skip=terminal::tests::find_bar_chevrons_step_older_up_and_newer_down"
    "--skip=terminal::tests::shipped_find_binding_opens_search_but_ctrl_f_reaches_the_program"
    # Clears PATH to /usr/bin:/bin and runs /usr/bin/printf under an
    # interactive /bin/sh; the sandbox has no /usr/bin, and its /bin/sh is
    # BusyBox, which greets with a banner.
    "--skip=remote_shell::tests::missing_shell_keeps_working_with_sh"
    # Races a thread against GPUI's test scheduler and fails now and then.
    "--skip=mods::lifecycle_tests::close_starts_native_work_before_releasing_the_copy"
    # Upstream's check that THIRD-PARTY-NOTICES matches the vendored sources;
    # postPatch changes one of them.
    "--skip=third_party_notices_are_current_and_complete"
  ];

  # The render and pixel tests draw real frames, on Mesa's software Vulkan
  # driver; the test binaries don't get the RUNPATH entries from postFixup.
  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    export VK_DRIVER_FILES=${mesa}/share/vulkan/icd.d/lvp_icd.${stdenv.hostPlatform.parsed.cpu.name}.json
    export LD_LIBRARY_PATH=${lib.makeLibraryPath dlopenLibs}
    # The pixel tests also lay out text, and the sandbox has no fonts.
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ dejavu_fonts ]; }}
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "herdr-app";
      desktopName = "Herdr";
      comment = "Terminals and coding agents that keep running";
      exec = "herdr-app";
      icon = "herdr-app";
      terminal = false;
      categories = [ "Development" ];
      startupWMClass = "herdr-app";
    })
  ];

  postInstall = ''
    install -Dm644 LICENSE THIRD-PARTY-NOTICES -t $out/share/licenses/herdr-desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 assets/icons/herdr-ui-icon-clean.svg \
      $out/share/icons/hicolor/scalable/apps/herdr-app.svg
  ''
  # The app bundle scripts/install-macos builds, without its ad-hoc signature.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    app=$out/Applications/Herdr.app
    mkdir -p $app/Contents/MacOS $app/Contents/Resources
    mv $out/bin/herdr-app $app/Contents/MacOS/Herdr
    ln -s $app/Contents/MacOS/Herdr $out/bin/herdr-app
    cp assets/icons/Herdr.icns $app/Contents/Resources/Herdr.icns
    sed -n '/<?xml/,/<\/plist>/p' scripts/install-macos > $app/Contents/Info.plist
  '';

  # A RUNPATH entry rather than LD_LIBRARY_PATH: the app starts herdr-core,
  # which passes its environment on to every terminal. This runs after fixup,
  # which drops RUNPATH entries the binary doesn't link against.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    description = "Desktop app for persistent terminals and coding agents";
    homepage = "https://github.com/herdrdev/herdr-app";
    changelog = "https://github.com/herdrdev/herdr-app/blob/v${finalAttrs.version}/CHANGELOG.md";
    # The binary also includes libghostty-vt, QuickJS, fonts and icons under
    # other free licenses; see share/licenses/herdr-desktop/THIRD-PARTY-NOTICES.
    license = with lib.licenses; [
      asl20
      ofl
      mit # libghostty-vt, Symbols Nerd Font
    ];
    maintainers = with lib.maintainers; [
      iamppborah
      munksgaard
      tophcodes
    ];
    mainProgram = "herdr-app";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

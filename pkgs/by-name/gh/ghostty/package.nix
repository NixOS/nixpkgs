{
  lib,
  stdenv,
  bzip2,
  callPackage,
  fetchFromGitHub,
  fontconfig,
  freetype,
  glib,
  glslang,
  harfbuzz,
  libGL,
  libX11,
  libadwaita,
  ncurses,
  nixosTests,
  oniguruma,
  pandoc,
  pkg-config,
  removeReferencesTo,
  versionCheckHook,
  wrapGAppsHook4,
  zig_0_13,
  # Usually you would override `zig.hook` with this, but we do that internally
  # since upstream recommends a non-default level
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/PACKAGING.md#build-options
  optimizeLevel ? "ReleaseFast",
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/build.zig#L106
  withAdwaita ? true,
}:
let
  zig_hook = zig_0_13.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=${optimizeLevel} --color off";
  };

  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/apprt.zig#L72-L76
  appRuntime = if stdenv.hostPlatform.isLinux then "gtk" else "none";
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/font/main.zig#L94
  fontBackend = if stdenv.hostPlatform.isDarwin then "coretext" else "fontconfig_freetype";
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/renderer.zig#L51-L52
  renderer = if stdenv.hostPlatform.isDarwin then "metal" else "opengl";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ghostty";
  version = "1.1.2";
  outputs = [
    "out"
    "man"
    "shell_integration"
    "terminfo"
    "vim"
  ];

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HZiuxnflLT9HXU7bc0xrk5kJJHQGNTQ2QXMZS7bE2u8=";
  };

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
    zig = zig_0_13;
  };

  strictDeps = true;

  nativeBuildInputs =
    [
      ncurses
      pandoc
      pkg-config
      removeReferencesTo
      zig_hook
    ]
    ++ lib.optionals (appRuntime == "gtk") [
      glib # Required for `glib-compile-schemas`
      wrapGAppsHook4
    ];

  buildInputs =
    [
      glslang
      oniguruma
    ]
    ++ lib.optional (appRuntime == "gtk" && withAdwaita) libadwaita
    ++ lib.optional (appRuntime == "gtk") libX11
    ++ lib.optional (renderer == "opengl") libGL
    ++ lib.optionals (fontBackend == "fontconfig_freetype") [
      bzip2
      fontconfig
      freetype
      harfbuzz
    ];

  zigBuildFlags =
    [
      "--system"
      "${finalAttrs.deps}"
      "-Dversion-string=${finalAttrs.version}"

      "-Dapp-runtime=${appRuntime}"
      "-Dfont-backend=${fontBackend}"
      "-Dgtk-adwaita=${lib.boolToString withAdwaita}"
      "-Drenderer=${renderer}"
    ]
    ++ lib.mapAttrsToList (name: package: "-fsys=${name} --search-prefix ${lib.getLib package}") {
      inherit glslang;
    };

  zigCheckFlags = finalAttrs.zigBuildFlags;

  doCheck = true;

  /**
    Ghostty really likes all of it's resources to be in the same directory, so link them back after we split them

    - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/os/resourcesdir.zig#L11-L52
    - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/termio/Exec.zig#L745-L750
    - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/termio/Exec.zig#L818-L834

    terminfo and shell integration should also be installable on remote machines

    ```nix
    { pkgs, ... }: {
      environment.systemPackages = [ pkgs.ghostty.terminfo ];

      programs.bash = {
        interactiveShellInit = ''
          if [[ "$TERM" == "xterm-ghostty" ]]; then
            builtin source ${pkgs.ghostty.shell_integration}/bash/ghostty.bash
          fi
        '';
      };
    }
    ```
  */
  postFixup = ''
    ln -s $man/share/man $out/share/man

    moveToOutput share/terminfo $terminfo
    ln -s $terminfo/share/terminfo $out/share/terminfo

    mv $out/share/ghostty/shell-integration $shell_integration
    ln -s $shell_integration $out/share/ghostty/shell-integration

    mv $out/share/vim/vimfiles $vim
    rmdir $out/share/vim
    ln -s $vim $out/share/vim-plugins


    remove-references-to -t ${finalAttrs.deps} $out/bin/.ghostty-wrapped
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) allTerminfo;
      nixos = nixosTests.terminal-emulators.ghostty;
    };
  };

  meta = {
    description = "Fast, native, feature-rich terminal emulator pushing modern features";
    longDescription = ''
      Ghostty is a terminal emulator that differentiates itself by being
      fast, feature-rich, and native. While there are many excellent terminal
      emulators available, they all force you to choose between speed,
      features, or native UIs. Ghostty provides all three.
    '';
    homepage = "https://ghostty.org/";
    downloadPage = "https://ghostty.org/download";
    changelog = "https://ghostty.org/docs/install/release-notes/${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.mit;
    mainProgram = "ghostty";
    maintainers = with lib.maintainers; [
      jcollie
      pluiedev
      getchoo
    ];
    outputsToInstall = [
      "out"
      "man"
      "shell_integration"
      "terminfo"
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # Issues finding the SDK in the sandbox
    broken = stdenv.hostPlatform.isDarwin;
  };
})

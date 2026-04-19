{
  lib,
  stdenv,
  blueprint-compiler,
  bzip2,
  callPackage,
  fetchFromGitHub,
  fontconfig,
  freetype,
  glib,
  glslang,
  gst_all_1,
  gtk4-layer-shell,
  harfbuzz,
  libadwaita,
  libGL,
  libx11,
  libxml2,
  ncurses,
  nixosTests,
  oniguruma,
  pandoc,
  pkg-config,
  removeReferencesTo,
  versionCheckHook,
  wrapGAppsHook4,
  zig_0_15,

  # Upstream recommends a non-default level
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/PACKAGING.md#build-options
  optimizeLevel ? "ReleaseFast",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ghostty";
  version = "1.3.1";

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
    hash = "sha256-+ddMmUe9Jjkun4qqW8XFXVgwVZdVHsGWcQzndgIlBjQ=";
  };

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ncurses
    pandoc
    pkg-config
    removeReferencesTo
    zig_0_15

    # GTK frontend
    glib # Required for `glib-compile-schemas`
    wrapGAppsHook4
    blueprint-compiler
    libxml2 # `xmllint`
  ];

  buildInputs = [
    oniguruma

    # GTK frontend
    libadwaita
    libx11
    gtk4-layer-shell
    gst_all_1.gstreamer # Used for playing audio, e.g. audible bells
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base

    # OpenGL renderer
    glslang
    libGL

    # Font backend
    bzip2
    fontconfig
    freetype
    harfbuzz
  ];

  dontSetZigDefaultFlags = true;

  zigCheckFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dversion-string=${finalAttrs.version}"
    "-Dcpu=baseline"
  ]
  ++ lib.mapAttrsToList (name: package: "-fsys=${name} --search-prefix ${lib.getLib package}") {
    inherit glslang;
  };

  # Only specify the optimization level for the actual build.
  # Tests do not work on ReleaseFast as they rely on triggering
  # specific integrity violations within the internal data structures.
  zigBuildFlags = finalAttrs.zigCheckFlags ++ [
    "-Doptimize=${optimizeLevel}"
  ];

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

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) allTerminfo;
      nixos = nixosTests.terminal-emulators.ghostty;
    };
    updateScript = ./update.nu;
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
    ];
    platforms = lib.platforms.linux;
  };
})

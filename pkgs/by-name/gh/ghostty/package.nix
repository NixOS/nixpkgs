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
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/build.zig#L106
  withAdwaita ? true,
}:

let
  # Ghostty needs to be built with --release=fast, --release=debug and
  # --release=safe enable too many runtime safety checks.
  zig_hook = zig_0_13.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=ReleaseFast --color off";
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AHI1Z4mfgXkNwQA8xYq4tS0/BARbHL7gQUT41vCxQTM=";
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

  dontConfigure = true;
  # doCheck is set to false because unit tests currently fail inside the Nix sandbox.
  doCheck = false;
  doInstallCheck = true;

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

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

  outputs = [
    "out"
    "terminfo"
    "shell_integration"
    "vim"
  ];

  postInstall = ''
    mkdir -p "$terminfo/share"
    mv "$out/share/terminfo" "$terminfo/share/terminfo"
    ln -sf "$terminfo/share/terminfo" "$out/share/terminfo"

    mkdir -p "$shell_integration"
    mv "$out/share/ghostty/shell-integration" "$shell_integration/shell-integration"
    ln -sf "$shell_integration/shell-integration" "$out/share/ghostty/shell-integration"

    mv "$out/share/vim/vimfiles" "$vim"
    ln -sf "$vim" "$out/share/vim/vimfiles"
  '';

  preFixup = ''
    remove-references-to -t ${finalAttrs.deps} $out/bin/ghostty
  '';

  NIX_LDFLAGS = lib.optional (appRuntime == "gtk") "-lX11";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) allTerminfo;
      nixos = nixosTests.terminal-emulators.ghostty;
    };
  };

  meta = {
    homepage = "https://ghostty.org/";
    description = "Fast, native, feature-rich terminal emulator pushing modern features";
    longDescription = ''
      Ghostty is a terminal emulator that differentiates itself by being
      fast, feature-rich, and native. While there are many excellent terminal
      emulators available, they all force you to choose between speed,
      features, or native UIs. Ghostty provides all three.
    '';
    downloadPage = "https://ghostty.org/download";

    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ghostty";
    outputsToInstall = finalAttrs.outputs;
    maintainers = with lib.maintainers; [
      jcollie
      pluiedev
      getchoo
    ];
  };
})

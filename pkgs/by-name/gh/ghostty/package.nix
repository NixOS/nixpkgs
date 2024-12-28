{
  bzip2,
  callPackage,
  expat,
  fetchFromGitHub,
  fontconfig,
  freetype,
  glib,
  glslang,
  harfbuzz,
  lib,
  libadwaita,
  libGL,
  libpng,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  ncurses,
  nixosTests,
  oniguruma,
  pandoc,
  pkg-config,
  removeReferencesTo,
  stdenv,
  versionCheckHook,
  wrapGAppsHook4,
  zig_0_13,
  zlib,
}:
let
  # Ghostty needs to be built with --release=fast, --release=debug and
  # --release=safe enable too many runtime safety checks.
  zig_hook = zig_0_13.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=ReleaseFast --color off";
  };
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

  nativeBuildInputs = [
    glib # Required for `glib-compile-schemas`
    ncurses
    pandoc
    pkg-config
    removeReferencesTo
    wrapGAppsHook4
    zig_hook
  ];

  buildInputs = [
    bzip2
    expat
    fontconfig
    freetype
    glslang
    harfbuzz
    libadwaita
    libGL
    libpng
    libX11
    libXcursor
    libXi
    libXrandr
    oniguruma
    zlib
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

  NIX_LDFLAGS = [ "-lX11" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

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

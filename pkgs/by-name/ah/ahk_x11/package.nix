{
  lib,
  stdenv,
  fetchFromGitHub,
  crystal,
  copyDesktopItems,
  linkFarm,
  fetchgit,

  gtk3,
  libxkbcommon,
  xorg,
  libnotify,
  gobject-introspection, # needed to build gi-crystal
  openbox,
  xvfb-run,
  xdotool,

  buildDevTarget ? false, # the dev version prints debug info
}:

# NOTICE: AHK_X11 from this package does not support compiling scripts into portable executables.
let
  pname = "ahk_x11";
  version = "1.0.4";

  inherit (xorg)
    libXinerama
    libXtst
    libXext
    libXi
    ;

in
crystal.buildCrystalPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "phil294";
    repo = "AHK_X11";
    rev = version;
    hash = "sha256-Kxe0tLbER1XFnnfUUIiy9CgCgz2qK21AIk4DfHymKlI=";
    fetchSubmodules = true;
  };

  # Fix build problems and the following UX problem:
  # Without this patch, the binary launches a graphical installer GUI that is useless with system-wide installation.
  # With this patch, it prompts to use -h for help.
  patches = [ ./adjust.patch ];

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  preBuild = ''
    mkdir bin
    cd lib/gi-crystal
    shards build -Dpreview_mt --release --no-debug
    cd ../..
    cp lib/gi-crystal/bin/gi-crystal bin
  '';

  postBuild = lib.optionalString buildDevTarget ''
    mv bin/ahk_x11.dev bin/ahk_x11
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    install -Dm644 -t $out/share/licenses/ahk_x11/ LICENSE
    install -Dm644 -t $out/share/pixmaps/ assets/ahk_x11.png
    install -Dm644 -t $out/share/applications/ assets/*.desktop
    install -Dm644 assets/ahk_x11-mime.xml $out/share/mime/packages/ahk_x11.xml
  '';

  buildInputs = [
    gtk3
    libxkbcommon
    libXinerama
    libXtst
    libXext
    libXi
    libnotify
  ];
  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
  ];
  nativeCheckInputs = [
    xvfb-run
    openbox
    xdotool
  ];

  buildTargets = if buildDevTarget then "bin/ahk_x11.dev" else "bin/ahk_x11";
  checkTarget = "test-dev";

  # The tests fail with AtSpi failure. This means it lacks assistive technologies:
  # https://github.com/phil294/AHK_X11?tab=readme-ov-file#accessibility
  # I don't know how to fix it for xvfb and openbox.
  doCheck = false;

  meta = {
    description = "AutoHotkey for X11";
    homepage = "https://phil294.github.io/AHK_X11";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "ahk_x11";
  };
}

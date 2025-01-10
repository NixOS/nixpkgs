{
  alsa-lib,
  autoPatchelfHook,
  buildPackages,
  dbus,
  fetchFromGitHub,
  fontconfig,
  installShellFiles,
  lib,
  libdecor,
  libGL,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXrender,
  pkg-config,
  scons,
  speechd-minimal,
  stdenv,
  udev,
  vulkan-loader,
  wayland,
  wayland-scanner,
  withDbus ? true,
  withDebug ? false,
  withFontconfig ? true,
  withPlatform ? "linuxbsd",
  withPrecision ? "single",
  withPulseaudio ? true,
  withSpeechd ? true,
  withTarget ? "editor",
  withTouch ? true,
  withUdev ? true,
  # Wayland in Godot requires X11 until upstream fix is merged
  # https://github.com/godotengine/godot/pull/73504
  withWayland ? true,
  withX11 ? true,
}:
assert lib.asserts.assertOneOf "withPrecision" withPrecision [
  "single"
  "double"
];
let
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (
    k: v: if builtins.isString v then "${k}=${v}" else "${k}=${builtins.toJSON v}"
  );
in
stdenv.mkDerivation rec {
  pname = "godot4";
  version = "4.3-stable";
  commitHash = "77dcf97d82cbfe4e4615475fa52ca03da645dbd8";

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    rev = commitHash;
    hash = "sha256-v2lBD3GEL8CoIwBl3UoLam0dJxkLGX0oneH6DiWkEsM=";
  };

  outputs = [
    "out"
    "man"
  ];

  # Set the build name which is part of the version. In official downloads, this
  # is set to 'official'. When not specified explicitly, it is set to
  # 'custom_build'. Other platforms packaging Godot (Gentoo, Arch, Flatpack
  # etc.) usually set this to their name as well.
  #
  # See also 'methods.py' in the Godot repo and 'build' in
  # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
  BUILD_NAME = "nixpkgs";

  # Required for the commit hash to be included in the version number.
  #
  # `methods.py` reads the commit hash from `.git/HEAD` and manually follows
  # refs. Since we just write the hash directly, there is no need to emulate any
  # other parts of the .git directory.
  #
  # See also 'hash' in
  # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
  preConfigure = ''
    mkdir -p .git
    echo ${commitHash} > .git/HEAD
  '';

  # From: https://github.com/godotengine/godot/blob/4.2.2-stable/SConstruct
  sconsFlags = mkSconsFlagsFromAttrSet {
    # Options from 'SConstruct'
    precision = withPrecision; # Floating-point precision level
    production = true; # Set defaults to build Godot for use in production
    platform = withPlatform;
    target = withTarget;
    debug_symbols = withDebug;

    # Options from 'platform/linuxbsd/detect.py'
    dbus = withDbus; # Use D-Bus to handle screensaver and portal desktop settings
    fontconfig = withFontconfig; # Use fontconfig for system fonts support
    pulseaudio = withPulseaudio; # Use PulseAudio
    speechd = withSpeechd; # Use Speech Dispatcher for Text-to-Speech support
    touch = withTouch; # Enable touch events
    udev = withUdev; # Use udev for gamepad connection callbacks
    wayland = withWayland; # Compile with Wayland support
    x11 = withX11; # Compile with X11 support
  };

  enableParallelBuilding = true;

  strictDeps = true;

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.stdenv.cc
    pkg-config
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    pkg-config
    scons
  ] ++ lib.optionals withWayland [ wayland-scanner ];

  runtimeDependencies =
    [
      alsa-lib
      libGL
      vulkan-loader
    ]
    ++ lib.optionals withX11 [
      libX11
      libXcursor
      libXext
      libXfixes
      libXi
      libXinerama
      libxkbcommon
      libXrandr
      libXrender
    ]
    ++ lib.optionals withWayland [
      libdecor
      wayland
    ]
    ++ lib.optionals withDbus [
      dbus
      dbus.lib
    ]
    ++ lib.optionals withFontconfig [
      fontconfig
      fontconfig.lib
    ]
    ++ lib.optionals withPulseaudio [ libpulseaudio ]
    ++ lib.optionals withSpeechd [ speechd-minimal ]
    ++ lib.optionals withUdev [ udev ];

  dontStrip = withDebug;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot4

    installManPage misc/dist/linux/godot.6

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/org.godotengine.Godot4.desktop"
    substituteInPlace "$out/share/applications/org.godotengine.Godot4.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot4" \
      --replace "Godot Engine" "Godot Engine 4"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/godotengine/godot/releases/tag/${version}";
    description = "Free and Open Source 2D and 3D game engine";
    homepage = "https://godotengine.org";
    license = lib.licenses.mit;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      shiryel
      superherointj
    ];
    mainProgram = "godot4";
  };
}

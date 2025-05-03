{
  lib,
  stdenv,
  protobuf,
  fetchFromGitLab,
  rustPlatform,
  symlinkJoin,

  # nativeBuildInputs
  blueprint-compiler,
  cargo,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  rustc,
  wrapGAppsHook4,

  # buildInputs
  appstream-glib,
  cairo,
  cmake,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  graphene,
  gtk4,
  libGL,
  libadwaita,
  libdrm,
  libgbm,
  missioncenter-magpie,
  pango,
  sqlite,
  udev,
  vulkan-loader,
  wayland,

  versionCheckHook,
}:

let
  # magpie = stdenv.mkDerivation {
  #   pname = "magpie";
  #   version = "0-unstable-2025-05-02";

  #   src = fetchFromGitLab {
  #     owner = "mission-center-devs";
  #     repo = "gng";
  #     rev = "dcf9672ef314eb77336edea9b6ccd10de30e53d4";
  #     hash = "sha256-Y2ZIk9SAzw98HAHuMGkLMnxvebMQEGYxSbQW4S4QY44=";
  #   };

  #   # useFetchCargoVendor = true;
  #   # cargoHash = "sha256-WVXMeW3pF3TCJ9MBfK3Q76/pJ4/W09KPjCNqyIzzcvg=";

  #   nativeBuildInputs = [
  #   ];

  #   buildInputs = [
  #     libdrm
  #     sqlite
  #     vulkan-loader
  #   ];

  #   meta = {
  #     description = "Set of executables and binaries for ";
  #     homepage = "https://gitlab.com/mission-center-devs/gng";
  #     license = lib.licenses.unfree; # FIXME: nix-init did not find a license
  #     maintainers = with lib.maintainers; [ GaetanLepage ];
  #     mainProgram = "magpie";
  #   };
  # };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mission-center";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    tag = "v${finalAttrs.version}";
    hash = "sha256-82pLzLvfZbm68GHpZsLNQAnRboOeO8nl4+gAiUqwS88=";
  };

  patches = [
    ./dont-vendor-magpie.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-1Bcxp0EuHbJrLQIb2STLNIL2BM2eOgL8ftx4g1o/JY4=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    libxml2
    meson
    ninja
    pkg-config
    python3
    protobuf # for protoc
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    appstream-glib
    blueprint-compiler
    cairo
    cmake
    dbus
    desktop-file-utils
    gdk-pixbuf
    gettext
    glib
    graphene
    gtk4
    libGL
    libadwaita
    libdrm
    libgbm
    missioncenter-magpie
    pango
    sqlite
    udev
    vulkan-loader
    wayland
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${builtins.placeholder "out"}/bin/missioncenter";
  doInstallCheck = true;

  env = {
    # Make sure libGL and libvulkan can be found by dlopen()
    # RUSTFLAGS = toString (
    #   map (flag: "-C link-arg=" + flag) [
    #     "-Wl,--push-state,--no-as-needed"
    #     "-lGL"
    #     "-lvulkan"
    #     "-Wl,--pop-state"
    #   ]
    # );
  };

  passthru = {
    magpie = missioncenter-magpie;
  };

  meta = {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    changelog = "https://gitlab.com/mission-center-devs/mission-center/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      getchoo
    ];
    platforms = lib.platforms.linux;
    mainProgram = "missioncenter";
  };
})

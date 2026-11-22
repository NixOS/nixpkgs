{
  lib,
  stdenv,
  dbus,
  desktop-file-utils,
  fetchgit,
  gitUpdater,
  gpu-screen-recorder,
  gpu-screen-recorder-notification,
  gsettings-desktop-schemas,
  libcap,
  libdrm,
  libglvnd,
  libpulseaudio,
  libx11,
  libxcomposite,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  linuxHeaders,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  pango,
  pkg-config,
  wayland,
  wayland-scanner,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-ui";
  version = "1.15.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = finalAttrs.version;
    hash = "sha256-q7TBCwZCsyRfZtTGLGg785RBiBfgTxEmc28aNq91UKY=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    desktop-file-utils
    wayland-scanner
  ];
  buildInputs = [
    libx11
    libxrandr
    libxrender
    libxkbcommon
    libxcomposite
    libxfixes
    libxext
    libxi
    libxcursor
    libglvnd
    libpulseaudio
    libdrm
    dbus
    linuxHeaders
    wayland
    pango
    libcap
    gsettings-desktop-schemas
  ];

  mesonBuildType = "release";
  mesonFlags = [
    # must be handled in the nixos module as extra file permissions are stripped in the nix store
    (lib.mesonBool "capabilities" false)
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/gsr-ui" \
        --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
            gpu-screen-recorder-notification
          ]
        }"
    '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libglvnd ]} $out/bin/.gsr-ui-wrapped
  '';

  passthru = {
    tests.nixos = nixosTests.gpu-screen-recorder;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/about";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      AhmedAmr
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gsr-ui";
  };
})

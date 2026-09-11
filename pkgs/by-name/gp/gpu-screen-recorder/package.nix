{
  stdenv,
  lib,
  fetchgit,
  makeWrapper,
  meson,
  ninja,
  addDriverRunpath,
  pkg-config,
  libxcomposite,
  libpulseaudio,
  dbus,
  ffmpeg,
  wayland,
  wayland-scanner,
  vulkan-headers,
  pipewire,
  libdrm,
  libva,
  libglvnd,
  libxdamage,
  libxi,
  libxrandr,
  libxfixes,
  libjpeg_turbo,
  versionCheckHook,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder";
  version = "6.1.1";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder";
    tag = finalAttrs.version;
    hash = "sha256-I5q2bvCjoXkXue/rr6IhwwhdQkxMmf1MgaKEjh+IZP8=";
  };

  postPatch = ''
    substituteInPlace src/capture/v4l2.c src/image_writer.c \
      --replace-fail "libturbojpeg.so.0" "${lib.getLib libjpeg_turbo}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
    wayland-scanner
  ];

  depsBuildBuild = [ pkg-config ];

  buildInputs = [
    libxcomposite
    libpulseaudio
    dbus
    ffmpeg
    pipewire
    wayland
    vulkan-headers
    libdrm
    libva
    libxdamage
    libxi
    libxrandr
    libxfixes
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  mesonFlags = [
    # Install the upstream systemd unit
    (lib.mesonBool "systemd" true)
    # Enable Wayland support
    (lib.mesonBool "portal" true)
    # Handle by the module
    (lib.mesonBool "capabilities" false)
    (lib.mesonBool "nvidia_suspend_fix" false)
    # Disable upstream static ffmpeg build
    (lib.mesonBool "ffmpeg_static" false)
  ];

  postInstall = ''
    mkdir $out/bin/.wrapped
    mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
    makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libglvnd
          addDriverRunpath.driverLink
        ]
      }" \
      --prefix PATH : "${wrapperDir}" \
      --suffix PATH : "$out/bin"
    substituteInPlace $out/lib/systemd/user/gpu-screen-recorder.service \
      --replace-fail "ExecStart=gpu-screen-recorder" "ExecStart=$out/bin/gpu-screen-recorder"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder";
    maintainers = with lib.maintainers; [
      babbaj
      js6pak
      keenanweaver
    ];
    platforms = lib.platforms.linux;
  };
})

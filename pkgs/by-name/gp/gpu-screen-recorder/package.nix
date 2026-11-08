{
  lib,
  stdenv,
  addDriverRunpath,
  dbus,
  fetchFromGitHub,
  fetchgit,
  ffmpeg_9,
  libdrm,
  libglvnd,
  libjpeg_turbo,
  libpulseaudio,
  libva,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxi,
  libxrandr,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  nv-codec-headers-13,
  pipewire,
  pkg-config,
  versionCheckHook,
  vulkan-headers,
  wayland,
  wayland-scanner,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder";
  version = "6.1.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder";
    tag = finalAttrs.version;
    hash = "sha256-Y2u+C0ioSORKkEiKRLAABGzTSAnoFU3J7OIlNOC4MAQ=";
  };

  postPatch = ''
    substituteInPlace src/capture/v4l2.c src/image_writer.c \
      --replace-fail "libturbojpeg.so.0" "${lib.getLib libjpeg_turbo}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    addDriverRunpath
    pkg-config
    makeWrapper
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    finalAttrs.passthru.ffmpeg
    libxcomposite
    libpulseaudio
    dbus
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

  # Turns off the driver check, the patched ffmpeg negotiates the NVENC API at runtime
  env.NIX_CFLAGS_COMPILE = "-DGSR_FFMPEG_STATIC";

  mesonBuildType = "release";
  mesonFlags = [
    # Install the upstream systemd unit
    (lib.mesonBool "systemd" true)
    # Enable Wayland support
    (lib.mesonBool "portal" true)
    # Record audio from single applications
    (lib.mesonBool "app_audio" true)
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
      --prefix PATH : "${wrapperDir}" \
      --suffix PATH : "$out/bin"
    substituteInPlace $out/lib/systemd/user/gpu-screen-recorder.service \
      --replace-fail "ExecStart=gpu-screen-recorder" "ExecStart=$out/bin/gpu-screen-recorder"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libglvnd ]} $out/bin/.wrapped/gpu-screen-recorder
    addDriverRunpath $out/bin/.wrapped/gpu-screen-recorder
  '';

  passthru = {
    # Upstream's NVENC patch expects the versions in subprojects/{ffmpeg,nv-codec-headers}.wrap
    nv-codec-headers = nv-codec-headers-13.overrideAttrs (
      final: _: {
        version = "13.0.19.0";
        src = fetchFromGitHub {
          owner = "FFmpeg";
          repo = "nv-codec-headers";
          tag = "n${final.version}";
          hash = "sha256-nDlRBedssEiQ7WGtswFxER531jAcAmd1YA6a+pZc5gY=";
        };
      }
    );
    ffmpeg =
      (ffmpeg_9.override {
        nv-codec-headers-12 = finalAttrs.passthru.nv-codec-headers;
      }).overrideAttrs
        (old: {
          patches = (old.patches or [ ]) ++ [
            "${finalAttrs.src}/subprojects/packagefiles/ffmpeg-nvenc-runtime-api-version.patch"
          ];
        });
    tests.nixos = nixosTests.gpu-screen-recorder;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      babbaj
      js6pak
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gpu-screen-recorder";
  };
})

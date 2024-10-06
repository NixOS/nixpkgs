{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  meson,
  ninja,
  addDriverRunpath,
  pkg-config,
  libXcomposite,
  libpulseaudio,
  dbus,
  ffmpeg,
  wayland,
  pipewire,
  libdrm,
  libva,
  libglvnd,
  libXdamage,
  libXi,
  libXrandr,
  libXfixes,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation {
  pname = "gpu-screen-recorder";
  version = "4.1.11";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.4.1.11.tar.gz";
    hash = "sha256-XCs40MzObfNtErxnN3rYQ722TAiREcbaJZet+VJfimg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
  ];

  buildInputs = [
    libXcomposite
    libpulseaudio
    dbus
    ffmpeg
    pipewire
    wayland
    libdrm
    libva
    libXdamage
    libXi
    libXrandr
    libXfixes
  ];

  mesonFlags = [
    # Enable Wayland support
    (lib.mesonBool "portal" true)
    # Handle by the module
    (lib.mesonBool "capabilities" false)
    (lib.mesonBool "systemd" false)
    (lib.mesonBool "nvidia_suspend_fix" false)
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
  '';

  meta = {
    description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    mainProgram = "gpu-screen-recorder";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}

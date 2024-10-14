{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  libXcomposite,
  libpulseaudio,
  dbus,
  ffmpeg,
  wayland,
  libdrm,
  libva,
  libglvnd,
  libXdamage,
  libXi,
  libXrandr,
  libXfixes,
  pipewire,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation {
  pname = "gpu-screen-recorder";
  version = "4.1.2";

  # Snapshot tarballs use the following versioning format:
  # printf "r%s.%s\n" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.r730.81e0b1c.tar.gz";
    hash = "sha256-x4EBMSMMg5sMTCdVsGTF9Op8Lb9qwdE5RbkwVJEhvcA=";
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
    wayland
    libdrm
    libva
    libXdamage
    libXi
    libXrandr
    libXfixes
    pipewire
  ];

  patches = [ ./0001-Don-t-install-files-using-absolute-paths.patch ];

  mesonFlags = [
    "-Dsystemd=true"

    # Capabilities are handled by security.wrappers if possible.
    "-Dcapabilities=false"
  ];

  postInstall = ''
    mkdir $out/bin/.wrapped
    mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
    makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
    --prefix LD_LIBRARY_PATH : ${libglvnd}/lib \
    --prefix PATH : ${wrapperDir} \
    --suffix PATH : $out/bin
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

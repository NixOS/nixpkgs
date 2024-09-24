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
  ffmpeg,
  wayland,
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
  version = "unstable-2024-07-05";

  # Snapshot tarballs use the following versioning format:
  # printf "r%s.%s\n" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.r641.48cd80f.tar.gz";
    hash = "sha256-hIEK8EYIxQTTiFePPZf4V0nsxqxkfcDeOG9GK9whn+0=";
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
    ffmpeg
    wayland
    libdrm
    libva
    libXdamage
    libXi
    libXrandr
    libXfixes
  ];

  patches = [ ./0001-Don-t-install-systemd-unit-files-using-absolute-path.patch ];

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

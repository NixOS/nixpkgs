{ stdenv
, lib
, fetchurl
, makeWrapper
, pkg-config
, libXcomposite
, libpulseaudio
, ffmpeg
, wayland
, libdrm
, libva
, libglvnd
, libXrandr
, libXfixes
}:

stdenv.mkDerivation {
  pname = "gpu-screen-recorder";
  version = "unstable-2024-05-21";

  # printf "r%s.%s\n" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.r594.e572073.tar.gz";
    hash = "sha256-MTBxhvkoyotmRUx1sRN/7ruXBYwIbOFQNdJHhZ3DdDk=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libXcomposite
    libpulseaudio
    ffmpeg
    wayland
    libdrm
    libva
    libXrandr
    libXfixes
  ];

  buildPhase = ''
    ./build.sh
  '';

  postInstall = ''
    install -Dt $out/bin gpu-screen-recorder gsr-kms-server
    mkdir $out/bin/.wrapped
    mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
    makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
    --prefix LD_LIBRARY_PATH : ${libglvnd}/lib \
    --suffix PATH : $out/bin
  '';

  meta = {
    description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}

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
}:

stdenv.mkDerivation {
  pname = "gpu-screen-recorder";
  version = "unstable-2023-11-18";

  # printf "r%s.%s\n" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.r418.5a8900e.tar.gz";
    hash = "sha256-Dal6KxQOTqoNH6e8lYk5XEXGFG/vzbguNFZ9yk9nKe0=";
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
    --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "A screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}

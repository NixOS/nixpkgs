{ stdenv, lib, fetchgit, makeWrapper, pkg-config, cudatoolkit, glew, libX11
, libXcomposite, glfw, libpulseaudio, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder";
  version = "1.0.0";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder";
    rev = "36fd4516db06bcb192e49055319d1778bbed0322";
    sha256 = "sha256-hYEHM4FOYcPmQ5Yxh520PKy8HiD+G0xv9hrn8SmA07w=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    glew
    libX11
    libXcomposite
    glfw
    libpulseaudio
    ffmpeg
  ];

  postPatch = ''
    substituteInPlace ./build.sh \
      --replace '/opt/cuda/targets/x86_64-linux/include' '${cudatoolkit}/targets/x86_64-linux/include' \
      --replace '/usr/lib64/libcuda.so' '${cudatoolkit}/targets/x86_64-linux/lib/stubs/libcuda.so'
  '';

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    install -Dt $out/bin/ gpu-screen-recorder
    wrapProgram $out/bin/gpu-screen-recorder --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '';

  meta = with lib; {
    description = "A screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitLab,
  glm,
  glslang,
  meson,
  ninja,
  openxr-loader,
  pkg-config,
  vulkan-headers,
  vulkan-loader,
  xxd,
  SDL2,
  makeWrapper,
  libGL,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "xrgears";
  version = "unstable-2021-06-19";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "6331b98e065494995c9cc4b48ccdd9d5ccaef461";
    sha256 = "sha256-buw2beTPIWScq+3VQjUyF+uOwS6VF+mnAPHZ2eFGZjc=";
  };

  nativeBuildInputs = [
    glslang
    meson
    ninja
    pkg-config
    xxd
    makeWrapper
  ];

  buildInputs = [
    glm
    openxr-loader
    vulkan-headers
    vulkan-loader
    glib
  ];

  fixupPhase = ''
    wrapProgram $out/bin/xrgears \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          SDL2
          libGL
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/monado/demos/xrgears";
    description = "OpenXR example using Vulkan for rendering";
    mainProgram = "xrgears";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

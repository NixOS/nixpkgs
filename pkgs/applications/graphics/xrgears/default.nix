{ lib, stdenv
, fetchFromGitLab
, glm
, glslang
, meson
, ninja
, openxr-loader
, pkg-config
, vulkan-headers
, vulkan-loader
, xxd
, SDL2
, makeWrapper
, libGL
, glib
}:

stdenv.mkDerivation {
  pname = "xrgears";
  version = "unstable-2023-12-09";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "6376389139a11eec16138148e17073bbe96f137d";
    sha256 = "sha256-B9mTCMrZ4Kr7d3EAsbWEQmTF0BgfleLxIjBdhTtp0IY=";
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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ SDL2 libGL ]}
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

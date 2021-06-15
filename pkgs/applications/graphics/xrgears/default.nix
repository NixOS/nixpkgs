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
}:

stdenv.mkDerivation rec {
  pname = "xrgears";
  version = "unstable-2020-04-15";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "d0bee35fbf8f181e8313f1ead13d88c4fb85c154";
    sha256 = "1k0k8dkclyiav99kf0933kyd2ymz3hs1p0ap2wbciq9s62jgz29i";
  };

  nativeBuildInputs = [
    glslang
    meson
    ninja
    pkg-config
    xxd
  ];

  buildInputs = [
    glm
    openxr-loader
    vulkan-headers
    vulkan-loader
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/monado/demos/xrgears";
    description = "An OpenXR example using Vulkan for rendering";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glslls";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "glsl-language-server";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-wi1QiqaWRh1DmIhwmu94lL/4uuMv6DnB+whM61Jg1Zs=";
  };

  nativeBuildInputs = [
    python3
    cmake
    ninja
  ];

  cmakeFlags = [
    # CMake 4 dropped support of versions lower than 3.5,
    # versions lower than 3.10 are deprecated.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  meta = {
    description = "Language server implementation for GLSL";
    mainProgram = "glslls";
    homepage = "https://github.com/svenstaro/glsl-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ declan ];
    platforms = lib.platforms.linux;
  };
})

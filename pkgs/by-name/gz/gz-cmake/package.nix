{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "gz-cmake${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-BWgRm+3UW65Cu7TqXtFFG05JlYF52dbpAsIE8aDnJM0=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  meta = {
    description = "CMake modules to build Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  nix-update-script,
}:
let
  version = "4.1.1";
  versionPrefix = "gz-cmake${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-BWgRm+3UW65Cu7TqXtFFG05JlYF52dbpAsIE8aDnJM0=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  # Extract the version by matching the tag's prefix.
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
  };

  meta = {
    description = "CMake modules to build Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  python3,
  nix-update-script,
}:
let
  version = "4.2.0";
  versionPrefix = "gz-cmake${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-+bMOcGWfcwPhxR9CBp4iH02CZC4oplCjsTDpPDsDnSs=";
  };

  postPatch = ''
    patchShebangs examples/test_c_child_requires_c_no_deps.bash
    substituteInPlace examples/CMakeLists.txt --replace-fail \
      "$""{CMAKE_INSTALL_LIBDIR}" "${if stdenv.hostPlatform.isDarwin then "lib" else "lib64"}"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILDSYSTEM_TESTING" finalAttrs.doCheck)
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

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

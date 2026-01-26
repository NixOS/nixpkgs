{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  cmake,
  assimp,
  ffmpeg,
  freeimage,
  gdal,
  gz-cmake,
  gz-math,
  gz-utils,
  libuuid,
  spdlog,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "gz-common";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-common";
    rev = "gz-common${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-sY9g+AatS+ddYSUAjqumfZNi2JIc+DFbiVYMaWKMC78=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      gz-cmake
      gz-utils
      spdlog
      libuuid
    ]
    ++ lib.optionals (!finalAttrs.cmakeDefinitions.SKIP_av) [
      ffmpeg
    ]
    ++ lib.optionals (!finalAttrs.cmakeDefinitions.SKIP_events) [
      gz-math
    ]
    ++ lib.optionals (!finalAttrs.cmakeDefinitions.SKIP_geospatial) [
      gdal
      gz-math
    ]
    ++ lib.optionals (!finalAttrs.cmakeDefinitions.SKIP_graphics) [
      assimp

      # The package freeimage is currently marked unstable due to upstream inactivity,
      # but gz-sim requires gz-common to compile with component graphics.
      # See the gz-common upstream issue https://github.com/gazebosim/gz-common/issues/388
      freeimage

      gz-math
      tinyxml-2
    ]
    ++ lib.optionals (!finalAttrs.cmakeDefinitions.SKIP_io) [
      gz-math
    ];

  strictDeps = true;

  patches = [
    # Add missing #include <chrono> for Event.hh that uses std::chrono
    # From pull request https://github.com/gazebosim/gz-common/pull/664
    (fetchpatch {
      url = "https://github.com/gazebosim/gz-common/commit/683493c6068c243e158f7e097af8d0ccde04b787.patch?full_inedx=1";
      hash = "sha256-e4b0UYm42t7LQQQHx/3Jco8V09PF4mScdGiBCkWS4AU=";
    })
  ];

  postPatch = ''
    homeDirForTests="$PWD/test-home-dir"
    mkdir -p "$homeDirForTests"
    substituteInPlace src/SystemPaths_TEST.cc \
      --replace-fail 'homeDir = "/home"' "homeDir = \"$homeDirForTests\""
  '';

  cmakeDefinitions = {
    CMAKE_CXX_STANDARD = "23";
    SKIP_av = false;
    SKIP_events = false;
    SKIP_geospatial = false;
    SKIP_graphics = false;
    SKIP_io = false;
    SKIP_profiler = false;
  };

  cmakeFlags =
    # TODO(@ShamrockLee):
    # Remove after a unified way to specify CMake definitions becomes available.
    lib.mapAttrsToList (
      n: v:
      let
        specifiedType = finalAttrs.cmakeDefinitionTypes.${n} or "";
        type =
          if specifiedType != "" then
            specifiedType
          else if lib.isBool v then
            "bool"
          else
            "string";
      in
      if lib.toUpper type == "BOOL" then lib.cmakeBool n v else lib.cmakeOptionType type n v
    ) finalAttrs.cmakeDefinitions;

  doCheck = true;

  # Some test cases generate files (probably FIFOs or sockets)
  # which cannot afford parallel running.
  enableParallelChecking = false;

  preCheck = ''
    export HOME="$homeDirForTests/alice"
    mkdir -p "$HOME"
  '';

  postCheck = ''
    rm -r "$homeDirForTests"
    export HOME="/homeless-shelter"
  '';

  passthru = {
    tests =
      let
        attrsNotSkipped = lib.filterAttrs (n: v: lib.hasPrefix "SKIP_" n && !v) finalAttrs.cmakeDefinitions;
      in
      lib.mapAttrs' (
        n: _:
        let
          component = lib.removePrefix "SKIP_" n;
        in
        {
          name = "dependency-${component}";
          value = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
            cmakeDefinitions = previousAttrs.cmakeDefinitions // lib.mapAttrs (n': _: n != n') attrsNotSkipped;
            inherit component;
            preConfigure =
              ''
                _cmakePath=$(type -p cmake)
                cmake() {
                  "$_cmakePath" "$@" | tee -a cmake_output.log
                }
              ''
              + previousAttrs.preConfigure or "";
            postConfigure =
              previousAttrs.postConfigure or ""
              + ''
                unset cmake
                if grep --fixed-strings "Skipping the component [$component] because the following packages are missing" cmake_output.log; then
                  echo "ERROR: dependencies of component $component is not satisfied."
                  exit 1
                fi
              '';
          });
        }
      ) attrsNotSkipped
      // {
        dependency-minimal = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
          cmakeDefinitions = previousAttrs.cmakeDefinitions // lib.mapAttrs (n': _: true) attrsNotSkipped;
        });
      };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Gazebo common library";

    longDescription = ''
      '
            An audio-visual library supports processing audio and video files,
            a graphics library can load a variety 3D mesh file formats into a generic in-memory representation,
            and the core library of Gazebo Common containing functionality that spans Base64 encoding/decoding to thread pools
    '';
    homepage = "https://github.com/gazebosim/gz-common";
    changelog = "https://github.com/gazebosim/gz-common/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-common";
    platforms = lib.platforms.all;
  };
})

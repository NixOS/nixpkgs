{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  cmake,
  pkg-config,
  ninja,
  python3,
  libX11,
  libGL,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libxcb,
  callPackage,
}:
let
  submods = import ./submodules.nix;
  pyEnv = python3.withPackages (ps: [ ps.jinja2 ]);
in
stdenv.mkDerivation (finalAttrs: {
  name = "google-dawn";
  version = "v20260124.162112";
  src = fetchFromGitHub {
    owner = "google";
    repo = "dawn";
    rev = finalAttrs.version;
    hash = "sha256-dOYx58EsoPQm77FzHwSfMB4gORNQ1mv84coyAc4n1dM";
    fetchSubmodules = false;
  };

  buildInputs = [
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libxcb
    libGL
  ]
  ++ (map (sm: fetchgit sm.src) submods);

  nativeBuildInputs = [
    cmake
    ninja
    pyEnv
    pkg-config
  ];
  cmakeFlags = [
    "-GNinja"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DDAWN_BUILD_SAMPLES=OFF"
    "-DDAWN_USE_GLFW=ON"
    "-DDAWN_BUILD_PROTOBUF=OFF"
    "-DDAWN_FETCH_DEPENDENCIES=OFF"
    "-DTINT_BUILD_CMD_TOOLS=ON"
    "-DTINT_BUILD_SAMPLES=OFF"
    "-DTINT_BUILD_DOCS=OFF"
    "-DTINT_BUILD_TESTS=OFF"
    "-DDAWN_ENABLE_INSTALL=ON"
    "-DDAWN_BUILD_MONOLITHIC_LIBRARY=STATIC"
  ];

  unpackPhase = ''
    runHook preUnpack
    chmod +w $NIX_BUILD_TOP
    cp -r $src/* $NIX_BUILD_TOP
  ''
  +
    # Build a string for submodules
    (
      let
        listOfSubmodules = builtins.concatStringsSep "\n" (
          map (sm: ''
            echo "Installing submodule: ${sm.path}"
            mkdir -p "$NIX_BUILD_TOP/${sm.path}"
            chmod 777 "$NIX_BUILD_TOP/${sm.path}"
            cp -r ${fetchgit sm.src}/* "$NIX_BUILD_TOP/${sm.path}/"
          '') submods
        );
      in
      ''
        echo "=== Installing submodules ==="
        ${listOfSubmodules}
      ''
    )
  + ''
    # Empty ABSL_RANDOM_HWAES_X64_FLAGS for arm
    chmod -R +w $NIX_BUILD_TOP
    sed -i -e 's/-msse4.1//g' -e 's/-maes//g' $NIX_BUILD_TOP/third_party/abseil-cpp/absl/copts/GENERATED_AbseilCopts.cmake
    runHook postUnpack
  '';

  passthru.tests.cmake = callPackage ./test { };

  meta = {
    description = "Library for implementing WebGPU in C++";
    homepage = "https://github.com/google/dawn";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.theoparis ];
  };
})

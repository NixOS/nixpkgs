{
  lib,
  stdenv,
  applyPatches,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  nodejs_24,
  pipewire,
  libpulseaudio,
  range-v3,
  glaze,
  spdlog,
  fmt,
  openssl,
}:
let
  venmicVersion = "6.1.0";

  venmicSrc = fetchFromGitHub {
    owner = "Vencord";
    repo = "venmic";
    rev = "v${venmicVersion}";
    hash = "sha256-0UP8a2bfhWGsB2Lg/GeIBu4zw1zHnXbitT8vU+DLeEY=";
  };

  rohrkabelSrc = fetchFromGitHub {
    owner = "Curve";
    repo = "rohrkabel";
    rev = "v7.0";
    hash = "sha256-XlpLYTCtV5gzmv3w/7gRtkf4JGgSrWH/Laenxmd5Pj8=";
  };

  rohrkabelSrcPatched = applyPatches {
    name = "rohrkabel-src-patched";
    src = rohrkabelSrc;
    patches = [ ./rohrkabel-cmake.patch ];
  };

  channelSrc = fetchFromGitHub {
    owner = "Curve";
    repo = "channel";
    rev = "v2.3";
    hash = "sha256-lU4QdShUP64Tie5o7rh7rkGlHgiMcPaLWaczkVTl+Jc=";
  };

  ereignisSrc = fetchFromGitHub {
    owner = "Curve";
    repo = "ereignis";
    rev = "v3.1";
    hash = "sha256-1vP9gnC+Gzj07NabKPUSJdbbqLpvHwmXoAh+htZxnu8=";
  };

  boostCallableTraitsSrc = fetchFromGitHub {
    owner = "boostorg";
    repo = "callable_traits";
    rev = "boost-1.85.0";
    hash = "sha256-XbO+SB5QhKAJigL/SBl9OIIQl49u6pUuqAMguU8SftQ=";
  };

  tlExpectedSrc = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "v1.1.0";
    hash = "sha256-AuRU8VI5l7Th9fJ5jIc/6mPm0Vqbbt6rY8QCCNDOU50=";
  };

  nodeAddonApi = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-addon-api";
    rev = "v8.0.0";
    hash = "sha256-k3v8lK7uaEJvcaj1sucTjFZ6+i5A6w/0Uj9rYlPhjCE=";
  };

  cmakeDeps = [
    range-v3
    glaze
    spdlog
    fmt
  ];
in
stdenv.mkDerivation {
  pname = "venmic-addon";
  version = venmicVersion;

  src = venmicSrc;
  patches = [ ./venmic-cmake.patch ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    nodejs_24
    pipewire
    libpulseaudio
    openssl
  ]
  ++ cmakeDeps;

  cmakeFlags = [
    "-Dvenmic_addon=ON"
    "-Dvenmic_server=OFF"
    "-Dvenmic_prefer_remote=OFF"
    "-DTL_EXPECTED_SOURCE_DIR=${tlExpectedSrc}"
    "-DROHRKABEL_SOURCE_DIR=${rohrkabelSrcPatched}"
    "-DCHANNEL_SOURCE_DIR=${channelSrc}"
    "-DEREIGNIS_SOURCE_DIR=${ereignisSrc}"
    "-DBOOST_CALLABLE_TRAITS_SOURCE_DIR=${boostCallableTraitsSrc}"
    "-DCMAKE_JS_INC=${nodejs_24}/include/node;${nodeAddonApi}"
    "-DOPENSSL_ROOT_DIR=${openssl}"
  ];

  preConfigure = ''
    export CMAKE_PREFIX_PATH="${lib.makeSearchPath "lib/cmake" cmakeDeps}:${lib.makeSearchPath "share/cmake" cmakeDeps}"
  '';

  installPhase = ''
    runHook preInstall

    addon=$(find . -name "*.node" -maxdepth 6 | head -n1)
    if [ -z "$addon" ]; then
      echo "venmic: addon output not found" >&2
      exit 1
    fi

    mkdir -p $out
    cp "$addon" $out/venmic.node

    runHook postInstall
  '';
}

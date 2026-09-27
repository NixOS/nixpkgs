{
  lib,
  stdenv,
  fetchFromGitHub,

  # build
  cmake,
  pkg-config,

  # runtime
  expat,
  ipu7-camera-bins,
  jsoncpp,
  libtool,
  gst_all_1,
  libdrm,

  # Pick one of
  # - ipu7x (Lunar Lake)
  # - ipu75xa (Lunar Lake)
  ipuVersion ? "ipu7x",
}:
let
  ipuTarget =
    {
      "ipu7x" = "ipu_lnl";
      "ipu75xa" = "ipu_lnl";
    }
    .${ipuVersion};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${ipuVersion}-camera-hal";
  version = "20260629_1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu7-camera-hal";
    rev = finalAttrs.version;
    hash = "sha256-uiVPQBMHUBP9ZFzX0QMimIpgbmvm7JLTkD588V07iGw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_CAMHAL_ADAPTOR=ON"
    "-DBUILD_CAMHAL_PLUGIN=ON"
    "-DIPU_VERSIONS=${ipuVersion}"
    "-DUSE_STATIC_GRAPH=ON"
    "-DUSE_STATIC_GRAPH_AUTOGEN=ON"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  enableParallelBuilding = true;

  buildInputs = [
    expat
    ipu7-camera-bins
    jsoncpp
    libtool
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libdrm
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set (CMAKE_CXX_STANDARD 11)' \
                     'set (CMAKE_CXX_STANDARD 17)'
    substituteInPlace src/platformdata/JsonParserBase.h \
      --replace-fail '<jsoncpp/json/json.h>' '<json/json.h>'
  '';

  postInstall = ''
    mkdir -p $out/include/${ipuTarget}/
    cp -r $src/include $out/include/${ipuTarget}/libcamhal
  '';

  postFixup = ''
    for lib in $out/lib/*.so; do
      patchelf --add-rpath "${ipu7-camera-bins}/lib" $lib
    done
  '';

  passthru = {
    inherit ipuVersion ipuTarget;
  };

  meta = {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu7-camera-hal";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.aoli-al
      lib.maintainers.pseudocc
    ];
    platforms = [ "x86_64-linux" ];
  };
})

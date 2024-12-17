{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ragel,
  python3,
  util-linux,
  pkg-config,
  boost,
  pcre,
  withStatic ? false, # build only shared libs by default, build static+shared if true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyperscan";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "hyperscan";
    hash = "sha256-tzmVc6kJPzkFQLUM1MttQRLpgs0uckbV6rCxEZwk1yk=";
    rev = "v${finalAttrs.version}";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake
    ragel
    python3
    util-linux
    pkg-config
  ];

  cmakeFlags =
    [
      "-DBUILD_AVX512=ON"
    ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) "-DFAT_RUNTIME=ON"
    ++ lib.optional (withStatic) "-DBUILD_STATIC_AND_SHARED=ON"
    ++ lib.optional (!withStatic) "-DBUILD_SHARED_LIBS=ON";

  # hyperscan CMake is completely broken for chimera builds when pcre is compiled
  # the only option to make it build - building from source
  # In case pcre is built from source, chimera build is turned on by default
  preConfigure = lib.optional withStatic ''
    mkdir -p pcre
    tar xvf ${pcre.src} --strip-components 1 -C pcre
  '';

  postPatch = ''
    sed -i '/examples/d' CMakeLists.txt
    substituteInPlace libhs.pc.in \
      --replace "libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace "includedir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_INCLUDEDIR@"
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    bin/unit-hyperscan
    ${lib.optionalString withStatic ''bin/unit-chimera''}

    runHook postCheck
  '';

  meta = with lib; {
    description = "High-performance multiple regex matching library";
    longDescription = ''
      Hyperscan is a high-performance multiple regex matching library.
      It follows the regular expression syntax of the commonly-used
      libpcre library, but is a standalone library with its own C API.

      Hyperscan uses hybrid automata techniques to allow simultaneous
      matching of large numbers (up to tens of thousands) of regular
      expressions and for the matching of regular expressions across
      streams of data.

      Hyperscan is typically used in a DPI library stack.
    '';

    homepage = "https://www.hyperscan.io/";
    maintainers = with maintainers; [ avnik ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    license = licenses.bsd3;
  };
})

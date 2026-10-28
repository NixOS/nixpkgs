{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  argtable,
  catch2,
  curl,
  doxygen,
  hiredis,
  jsoncpp,
  libmicrohttpd,
  patchelf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjson-rpc-cpp";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "cinemast";
    repo = "libjson-rpc-cpp";
    sha256 = "sha256-YCCZN4y88AixQeo24pk6YHfSCsJz8jJ97Dg40KM08cQ=";
    rev = "v${finalAttrs.version}";
  };

  env.NIX_CFLAGS_COMPILE = "-I${catch2}/include/catch2";

  nativeBuildInputs = [
    pkg-config
    cmake
    doxygen
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
  ];

  buildInputs = [
    argtable
    catch2
    curl
    hiredis
    jsoncpp
    libmicrohttpd
  ];

  postPatch = ''
    for f in cmake/FindArgtable.cmake \
             src/stubgenerator/stubgenerator.cpp \
             src/stubgenerator/stubgeneratorfactory.cpp
    do
      sed -i -re 's/argtable2/argtable3/g' $f
    done

    sed -i -re 's#MATCHES "jsoncpp"#MATCHES ".*/jsoncpp/json$"#g' cmake/FindJsoncpp.cmake

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_policy(SET CMP0042 OLD)" ""

    # jsoncpp 1.9.7 dropped char const*/String const& overloads in favor of std::string_view.
    substituteInPlace cmake/CMakeCompilerSettings.cmake \
      --replace-fail "-std=c++11" "-std=c++17"
  '';

  preConfigure = ''
    mkdir -p Build/Install
    pushd Build
  '';

  # this hack is needed because the cmake scripts
  # require write permission to absolute paths
  configurePhase = ''
    runHook preConfigure
    cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/Install \
             -DCMAKE_INSTALL_LIBDIR=lib \
             -DCMAKE_BUILD_TYPE=Release \
             -DWITH_COVERAGE=OFF \
             ${lib.optionalString stdenv.hostPlatform.isDarwin "-DCMAKE_INSTALL_NAME_DIR=$out/lib -DCMAKE_INSTALL_RPATH=$out/lib"}
    runHook postConfigure
  '';

  preInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      function fixRunPath {
        p=$(patchelf --print-rpath $1)
        q="$p:${
          lib.makeLibraryPath [
            jsoncpp
            argtable
            libmicrohttpd
            curl
          ]
        }:$out/lib"
        patchelf --set-rpath $q $1
      }
    ''
    + ''
      mkdir -p $out
    '';

  postInstall = ''
    sed -i -re "s#-([LI]).*/Build/Install(.*)#-\1$out\2#g" Install/lib*/pkgconfig/*.pc
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for f in Install/lib*/*.so* $(find Install/bin -executable -type f); do
      fixRunPath $f
    done
  ''
  + ''
    cp -r Install/* $out
  '';

  installPhase = ''
    runHook preInstall
    make install
    runHook postInstall
  '';

  meta = {
    description = "C++ framework for json-rpc (json remote procedure call)";
    mainProgram = "jsonrpcstub";
    homepage = "https://github.com/cinemast/libjson-rpc-cpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ robertrichter ];
  };
})

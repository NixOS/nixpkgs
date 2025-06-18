{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  automaticcomponenttoolkit,
  pkg-config,
  fast-float,
  libzip,
  gtest,
  openssl,
  libuuid,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "lib3mf";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = "lib3mf";
    tag = "v${version}";
    hash = "sha256-XEwrJINiNpI2+1wXxczirci8VJsUVs5iDUAMS6jWuNk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include/lib3mf"
    "-DUSE_INCLUDED_ZLIB=OFF"
    "-DUSE_INCLUDED_LIBZIP=OFF"
    "-DUSE_INCLUDED_GTEST=OFF"
    "-DUSE_INCLUDED_SSL=OFF"
  ];

  buildInputs = [
    libzip
    gtest
    openssl
    zlib
  ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) libuuid;

  postPatch = ''
    # fix libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    sed -i 's,libdir=''${\(exec_\)\?prefix}/,libdir=,' lib3mf.pc.in

    # replace bundled binaries
    rm -r AutomaticComponentToolkit
    ln -s ${automaticcomponenttoolkit}/bin AutomaticComponentToolkit

    # unvendor Libraries
    rm -r Libraries/{fast_float,googletest,libressl,libzip,zlib}

    cat <<"EOF" >> Tests/CPP_Bindings/CMakeLists.txt
    find_package(GTest REQUIRED)
    target_link_libraries(''${TESTNAME} PRIVATE GTest::gtest)
    EOF

    mkdir Libraries/fast_float
    ln -s ${lib.getInclude fast-float}/include/fast_float Libraries/fast_float/Include

    # functions are no longer in openssl, remove them from test cleanup function
    substituteInPlace Tests/CPP_Bindings/Source/UnitTest_EncryptionUtils.cpp \
      --replace-warn "RAND_cleanup();" "" \
      --replace-warn "EVP_cleanup();" "" \
      --replace-warn "CRYPTO_cleanup_all_ex_data();" ""
  '';

  doCheck = true;

  meta = with lib; {
    description = "Reference implementation of the 3D Manufacturing Format file standard";
    homepage = "https://3mf.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}

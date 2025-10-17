{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lib3mf";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = "lib3mf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wq/dT/8m+em/qFoNNj6s5lyx/MgNeEBGSMBpuJiORqA=";
  };

  patches = [
    # some patches are required for the gcc 14 source build
    # remove next release
    # https://github.com/3MFConsortium/lib3mf/pull/413
    (fetchpatch {
      url = "https://github.com/3MFConsortium/lib3mf/pull/413/commits/96b2f5ec9714088907fe8a6f05633e2bbd82053f.patch?full_index=1";
      hash = "sha256-cJRc+SW1/6Ypf2r34yroVTxu4NMJWuoSmzsmoXogrUk=";
    })
    # https://github.com/3MFConsortium/lib3mf/pull/421
    (fetchpatch {
      url = "https://github.com/3MFConsortium/lib3mf/pull/421/commits/6d7b5709a4a1cf9bd55ae8b4ae999c9ca014f62c.patch?full_index=1";
      hash = "sha256-rGOyXZUZglRNMu1/oVhgSpRdi0pUa/wn5SFHCS9jVOY=";
    })
    (fetchpatch {
      name = "lib3mf-fix-cmake-4.patch";
      url = "https://github.com/3MFConsortium/lib3mf/commit/01325a73de25d2ad49e992b5b6294beb32298c92.patch";
      hash = "sha256-8vv2ydnDgvSKkGjpmk5ng1BGKK0okTMOeAoGwlKcziY=";
    })
  ];

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
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libuuid;

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/3MFConsortium/lib3mf/releases/tag/${finalAttrs.src.tag}";
    description = "Reference implementation of the 3D Manufacturing Format file standard";
    homepage = "https://3mf.io/";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.all;
  };
})

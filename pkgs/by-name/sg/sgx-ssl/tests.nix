# This package _builds_ (but doesn't run!) the sgx-ssl test enclave + harness.
# The whole package effectively does:
#
# ```
# SGX_MODE=${sgxMode} make -C Linux/sgx/test_app
# cp Linux/sgx/{TestApp,TestEnclave.signed.so} $out/bin
# ```
#
# OfBorg fails to run these tests since they require real Intel HW. That
# includes the simulation mode! The tests appears to do something fancy with
# cpuid and exception trap handlers that make them very non-portable.
#
# These tests are split out from the parent pkg since recompiling the parent
# takes like 30 min : )

{
  lib,
  openssl,
  sgx-psw,
  sgx-sdk,
  sgx-ssl,
  stdenv,
  which,
  opensslVersion ? throw "required parameter",
  sgxMode ? throw "required parameter", # "SIM" or "HW"
}:
stdenv.mkDerivation {
  inherit (sgx-ssl) postPatch src version;
  pname = sgx-ssl.pname + "-tests-${sgxMode}";

  postUnpack =
    sgx-ssl.postUnpack
    + ''
      sourceRootAbs=$(readlink -e $sourceRoot)
      packageDir=$sourceRootAbs/Linux/package

      # Do the inverse of 'make install' and symlink built artifacts back into
      # '$src/Linux/package/' to avoid work.
      mkdir $packageDir/lib $packageDir/lib64
      ln -s ${lib.getLib sgx-ssl}/lib/* $packageDir/lib/
      ln -s ${lib.getLib sgx-ssl}/lib64/* $packageDir/lib64/
      ln -sf ${lib.getDev sgx-ssl}/include/* $packageDir/include/

      # test_app needs some internal openssl headers.
      # See: tail end of 'Linux/build_openssl.sh'
      tar -C $sourceRootAbs/openssl_source -xf $sourceRootAbs/openssl_source/openssl-${opensslVersion}.tar.gz
      echo '#define OPENSSL_VERSION_STR "${opensslVersion}"' > $sourceRootAbs/Linux/sgx/osslverstr.h
      ln -s $sourceRootAbs/openssl_source/openssl-${opensslVersion}/include/crypto $sourceRootAbs/Linux/sgx/test_app/enclave/
      ln -s $sourceRootAbs/openssl_source/openssl-${opensslVersion}/include/internal $sourceRootAbs/Linux/sgx/test_app/enclave/
    '';

  nativeBuildInputs = [
    openssl.bin
    sgx-sdk
    which
  ];

  preBuild = ''
    # Need to regerate the edl header
    make -C Linux/sgx/libsgx_tsgxssl sgx_tsgxssl_t.c
  '';

  makeFlags = [
    "-C Linux/sgx/test_app"
    "SGX_MODE=${sgxMode}"
  ];

  installPhase = ''
    runHook preInstall

    # Enclaves can't be stripped after signing.
    install -Dm 755 Linux/sgx/test_app/TestEnclave.signed.so -t $TMPDIR/enclaves

    install -Dm 755 Linux/sgx/test_app/TestApp -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    # Move the enclaves where they actually belong.
    mv $TMPDIR/enclaves/*.signed.so* $out/bin/

    # HW SGX must runs against sgx-psw, not sgx-sdk.
    if [[ "${sgxMode}" == "HW" ]]; then
      patchelf \
        --set-rpath "$( \
          patchelf --print-rpath $out/bin/TestApp \
            | sed 's|${lib.getLib sgx-sdk}|${lib.getLib sgx-psw}|' \
        )" \
        $out/bin/TestApp
    fi
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
    mainProgram = "TestApp";
  };
}

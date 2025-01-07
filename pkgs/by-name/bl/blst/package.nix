{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blst";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "supranational";
    repo = "blst";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+Ae2cCVVEXnV/ftVOApxDcXM3COf/4DXXd1AOuGS5uc=";
  };

  buildPhase = ''
    runHook preBuild

    ./build.sh ${lib.optionalString stdenv.hostPlatform.isWindows "flavour=mingw64"}
    ./build.sh -shared ${lib.optionalString stdenv.hostPlatform.isWindows "flavour=mingw64"}

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,include}
    for lib in libblst.{a,so,dylib}; do
      if [ -f $lib ]; then
        cp $lib $out/lib/
      fi
    done
    cp bindings/{blst.h,blst_aux.h} $out/include

    for lib in blst.dll; do
      if [ -f $lib ]; then
        mkdir -p $out/bin
        cp $lib $out/bin/
      fi
    done

    mkdir -p $out/lib/pkgconfig
    cat <<EOF > $out/lib/pkgconfig/libblst.pc
    prefix=$out
    exec_prefix=''\\''${prefix}
    libdir=''\\''${exec_prefix}/lib
    includedir=''\\''${prefix}/include

    Name: libblst
    Description: ${finalAttrs.meta.description}
    URL: ${finalAttrs.meta.homepage}
    Version: ${finalAttrs.version}

    Cflags: -I''\\''${includedir}
    Libs: -L''\\''${libdir} -lblst
    Libs.private:
    EOF

    runHook postInstall
  '';

  # ensure we have the right install id set.  Otherwise the library
  # wouldn't be found during install.  The alternative would be to work
  # lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/libblst.dylib";
  # into the setup.sh
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libblst.dylib $out/lib/libblst.dylib
  '';

  doCheck = true;

  meta = with lib; {
    description = "Multilingual BLS12-381 signature library";
    homepage = "https://github.com/supranational/blst";
    license = licenses.isc;
    maintainers = with maintainers; [
      iquerejeta
      yvan-sraka
    ];
    platforms = platforms.all;
  };
})

{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  patchelfUnstable, # unstable is needed for --rename-dynamic-symbols support
  libusb-compat-0_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brscan3";
  version = "0.2.13-1";
  src =
    let
      system = stdenv.hostPlatform.system;
    in
    {
      "i686-linux" = fetchurl {
        url = "https://download.brother.com/welcome/dlf006641/${finalAttrs.pname}-${finalAttrs.version}.i386.deb";
        hash = "sha256-rQZmXKwyA1iT9hTZMF2r9zFFr0VPGutri3x/onAP4uY=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://download.brother.com/welcome/dlf006642/${finalAttrs.pname}-${finalAttrs.version}.amd64.deb";
        hash = "sha256-RGrfUxvzkDKJLpUEzjS3v4ieD4YowHMs67O4P6+zJ7g=";
      };
    }
    ."${system}" or (throw "unsupported system ${system}");

  nativeBuildInputs = [
    dpkg
    patchelfUnstable
  ];
  buildInputs = [ libusb-compat-0_1 ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    RESOURCES_PATH=local/Brother/sane
    mkdir -p $out/$RESOURCES_PATH
    cp -rp usr/$RESOURCES_PATH/* $out/$RESOURCES_PATH

    mkdir -p $out/bin
    ln -s ../$RESOURCES_PATH/brsaneconfig3 $out/bin/brsaneconfig3

    LIB_DIR=usr/lib${lib.optionalString stdenv.is64bit "64"}
    install -D $LIB_DIR/libbrscandec3.so.1.0.0 \
      $out/lib/libbrscandec3.so.1.0.0
    ln -s -T libbrscandec3.so.1.0.0 $out/lib/libbrscandec3.so
    ln -s -T libbrscandec3.so.1.0.0 $out/lib/libbrscandec3.so.1

    install -D $LIB_DIR/sane/libsane-brother3.so.1.0.7 \
      $out/lib/sane/libsane-brother3.so.1.0.7
    ln -s -T libsane-brother3.so.1.0.7 $out/lib/sane/libsane-brother3.so
    ln -s -T libsane-brother3.so.1.0.7 $out/lib/sane/libsane-brother3.so.1

    $CC -O3 -DOUT=\"$out\" -fPIC -shared \
      ${./fopen_wrapper.c} -o libfopen_wrapper.so
    install -D libfopen_wrapper.so $out/libexec/libfopen_wrapper.so

    mkdir -p $out/etc/sane.d
    echo "brother3" > $out/etc/sane.d/dll.conf

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/local/Brother/sane/brsaneconfig3

    patchelf --set-rpath $out/lib:${libusb-compat-0_1}/lib \
      $out/lib/sane/libsane-brother3.so.1.0.7

    echo 'fopen fopen_wrapped' > name-map
    patchelf \
      --add-needed $out/libexec/libfopen_wrapper.so \
      --rename-dynamic-symbols name-map \
      $out/lib/sane/libsane-brother3.so.1.0.7

    runHook postFixup
  '';

  meta = {
    description = "Brother brscan3 sane backend driver";
    homepage = "http://www.brother.com";
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.brotherEula;
    maintainers = [ lib.maintainers.marcin-serwin ];
  };
})

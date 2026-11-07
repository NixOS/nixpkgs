{
  stdenvNoCC,
  zig_0_16,
  makeWrapper,
  native-sdk,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "native-cli";
  inherit (native-sdk) version;
  strictDeps = true;
  __structuredAttrs = true;

  src = native-sdk;

  nativeBuildInputs = [
    makeWrapper
    zig_0_16
  ];

  configurePhase = ''
    runHook preConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $TMPDIR/zig-cache
    zig build cli lib --global-cache-dir $TMPDIR/zig-cache

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin $out/lib

    cp zig-out/bin/native $out/libexec/native
    makeWrapper $out/libexec/native $out/bin/native \
        --set NATIVE_SDK_PATH ${native-sdk}

    cp -r zig-out/lib/* $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "Toolkit for building native desktop apps";
    homepage = "https://native-sdk.dev";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ElSebas41 ];
  };
})

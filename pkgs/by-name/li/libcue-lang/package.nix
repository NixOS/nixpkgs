{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "libcue-lang";
  version = "0-unstable-2025-11-12";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "libcue";
    rev = "3dea836f38b69a36d1e87752c4bfa7e78d99fc04";
    hash = "sha256-ARWPFxM17pqfAuspNPR9wZSq+hcnTFuGlN+jm07sX/M=";
  };

  vendorHash = "sha256-iZhICV5FpkJyHl42gP0rPrxobHKFId54sVVES7JZR9E=";

  env.CGO_ENABLED = "1";

  buildPhase = ''
    runHook preBuild

    go build -buildmode=c-shared -o libcue${stdenv.hostPlatform.extensions.sharedLibrary} -v .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 libcue.h  $out/include/libcue.h
    install -Dm644 cue.h     $out/include/cue.h
    install -Dm644 libcue.so $out/lib/libcue.so

    # Create pkgconfig
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/libcue.pc <<EOF
    prefix=${placeholder "out"}
    libdir=''${prefix}/lib
    includedir=''${prefix}/include

    Name: libcue
    Description: ${finalAttrs.meta.description}
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lcue
    Cflags: -I\''${includedir}
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Use CUE from C and C-like languages";
    homepage = "https://cuelang.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nobbz ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})

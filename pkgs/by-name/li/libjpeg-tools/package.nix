{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjpeg-tools";
  version = "1.71";

  src = fetchFromGitHub {
    owner = "thorfdbg";
    repo = "libjpeg";
    rev = "25f71280913fde7400801772bbf885bb3e873242";
    hash = "sha256-40yb9EujJp9y1PnuYLcPxK31Kj2Q4UQ5YBwXQFYXI/Y=";
  };

  outputs = [
    "out"
    "lib"
  ];

  buildPhase = ''
    runHook preBuild
    make lib
    make final
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -m755 -D jpeg $out/bin/jpeg
    install -m644 -D libjpeg.so $lib/lib/libjpeg
    runHook postInstall
  '';

  doCheck = false; # no tests

  meta = {
    description = "A complete implementation of 10918-1 (JPEG) coming from jpeg.org (the ISO group) with extensions for HDR, lossless and alpha channel coding standardized as ISO/IEC 18477 (JPEG XT)";
    homepage = "https://github.com/thorfdbg/libjpeg";
    license = with lib.licenses; [ gpl3 ];
    changelog = "https://github.com/thorfdbg/libjpeg/README.history";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    mainProgram = "jpeg";
    # clang build fails with "ld: symbol(s) not found for architecture arm64" (on aarch64-darwin)
    broken = stdenv.hostPlatform.isDarwin;
  };
})

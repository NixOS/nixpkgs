{
  stdenv,
  fetchzip,
  lib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "camilladsp";
  version = "2.0.3";

  os =
    if stdenv.isDarwin then
      "macos"
    else if stdenv.isLinux then
      "linux"
    else
      "windows";

  arch =
    if lib.strings.hasInfix "aarch64" stdenv.system then
      "aarch64"
    else if lib.strings.hasInfix "x86_64" stdenv.system then
      "amd64"
    else if lib.strings.hasInfix "armv6" stdenv.system then
      "armv6"
    else if lib.strings.hasInfix "armv7" stdenv.system then
      "armv7"
    else
      "unknown_architecture";

  hash =
    if stdenv.system == "aarch64-darwin" then
      "sha256-AK8S1fhSBl+IoxkKT8v6m9aFWA1yjJ0qDLL4Tn/Nmfs="
    else if stdenv.system == "x86_64-darwin" then
      "sha256-rypnfht/lvQ0OZbqQ5gGFis5S68IOzka1+aGgtHWzBw="
    else if stdenv.system == "aarch64-linux" then
      "sha256-3G6rxDP0ntbXfhJh4zeS3gF8Hx2fH7Wvu32/ofzP7hI="
    else if stdenv.system == "x86_64-linux" then
      "sha256-dofL3SYfeFx4yyVjB8sePXqAp1Twtox6vDwxqUnwlRY="
    else if lib.strings.hasInfix stdenv.system "armv6" then
      "sha256-SXf5grrl50PU1e+BO0XIHW+4FCAA/3WMGjqntu4YLIo="
    else if lib.strings.hasInfix stdenv.system "armv7" then
      "sha256-wlit+maN/J8L1ey6YsmTXMzKu3OiEz2aNWD3VBtPoSU="
    else if stdenv.hostPlatform.isWindows then
      "sha256-fTB7hOcc/4Gbi1regzk0SvOfnJU1m3VxOE/6I2kzOjQ="
    else
      lib.fakeHash;

  archiveExtension = if stdenv.hostPlatform.isWindows then "zip" else "tar.gz";

  src = fetchzip {
    url = "https://github.com/HEnquist/camilladsp/releases/download/v${finalAttrs.version}/camilladsp-${finalAttrs.os}-${finalAttrs.arch}.${finalAttrs.archiveExtension}";
    hash = "${finalAttrs.hash}";
  };

  installPhase = ''
    mkdir -p $out/bin $out/bin/
    cp -r $srcDarwin/* $out/bin/
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://henquist.github.io/";
    changelog = "https://henquist.github.io/";
    description = "A flexible cross-platform IIR and FIR engine for crossovers, room correction etc.";
    license = lib.licenses.gpl3Only;
    mainProgram = "camilladsp";
    platforms = lib.platforms.darwin ++ lib.platforms.linux ++ lib.platforms.windows;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ robertrichter ];
  };
})

{
  lib,
  stdenv,
  cmake,
  ninja,
  bgfx,
}:

stdenv.mkDerivation {
  pname = "bgfx-consumer-test";
  inherit (bgfx) version;
  src = lib.fileset.toSource {
    root = ./test;
    fileset = lib.fileset.unions [
      ./test/CMakeLists.txt
      ./test/main.cpp
    ];
  };
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [ bgfx ];
  cmakeFlags = [
    (lib.cmakeFeature "EXPECTED_BGFX_VERSION" (lib.head (lib.splitString "-" bgfx.version)))
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 consumer $out/bin/bgfx-consumer-test
    runHook postInstall
  '';

  # No display server or GPU is needed by the Noop renderer.
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/bgfx-consumer-test
    runHook postInstallCheck
  '';
}

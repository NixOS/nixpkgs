{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gflags,
  libsodium,
  openssl,
  protobuf,
  zlib,
  catch2,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eternal-terminal";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    tag = "et-v${finalAttrs.version}";
    hash = "sha256-uZnjtSubTljFlbIZEznfEmNRaUWsuZotRapn0wexkow=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gflags
    libsodium
    openssl
    protobuf
    zlib
  ];

  preBuild = ''
    mkdir -p ../external_imported/Catch2/single_include/catch2
    cp ${catch2}/include/catch2/catch.hpp ../external_imported/Catch2/single_include/catch2/catch.hpp
  '';

  cmakeFlags = [
    "-DDISABLE_VCPKG=TRUE"
    "-DDISABLE_SENTRY=TRUE"
    "-DDISABLE_CRASH_LOG=TRUE"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = toString [ "-std=c++17" ];
  };

  doCheck = true;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  checkPhase = ''
    ctest --output-on-failure -E 'et-test\.LargeInputNoDeadlock'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remote shell that automatically reconnects without interrupting the session";
    homepage = "https://eternalterminal.dev/";
    changelog = "https://github.com/MisterTea/EternalTerminal/releases/tag/et-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jshort
      tomasrivera
    ];
    mainProgram = "et";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

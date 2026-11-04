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
  ctestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

let
  disabledTests = [
    "et-test.LargeInputNoDeadlock"
    "et-test.Daemon pid writes create private files and replace stale contents"
    "et-test.sessionHasEnded without master EOF while descendant holds PTY slave"
    "et-test.Creation"
    "et-test.Telemetry creates private configuration and preserves its id"
    "et-test.Telemetry bounds existing configuration reads and migrates permissions"
    "et-test.Control-mode PTY: SIGKILL of htm lets htmd accept a new client"
    "et-test.Control-mode PTY: detach leaves htmd running"
    "et-test.RouterRestartRealPtySurvives"
    "et-test.Server fifo accepts a parent writable by the user private group"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "eternal-terminal";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    tag = "et-v${finalAttrs.version}";
    hash = "sha256-X3yJMsrnF9cEStv5nhvFfdmju/gJRWzEpgmy/kItFlA=";
  };

  patches = [
    ./thread-pool-c++20-result-of.patch
  ];

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

  doCheck = true;
  doInstallCheck = true;

  nativeCheckInputs = [
    ctestCheckHook
    writableTmpDirAsHomeHook
  ];

  inherit disabledTests;

  preCheck = ''
    disabledTests=(
      ${lib.concatMapStringsSep "\n" (test: ''"${test}"'') disabledTests}
    )
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

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

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

stdenv.mkDerivation (finalAttrs: {
  pname = "eternal-terminal";
  version = "7.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    tag = "et-v${finalAttrs.version}";
    hash = "sha256-X3yJMsrnF9cEStv5nhvFfdmju/gJRWzEpgmy/kItFlA=";
  };

  patches = [
    ./thread-pool-c++20-result-of.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Use the SDK supplied by stdenv instead of an impure Xcode installation.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")' ""
  '';

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

  # Tests use loopback TCP sockets.
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    ctestCheckHook
    writableTmpDirAsHomeHook
  ];

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Darwin's proc_name reports "coreutils" for the sleep symlink.
    "et-test.HtmServer automatic-renames window from pane command"
    "et-test.PipeUserTerminal keeps binary stdout and stderr separate"
    # This test times out on Darwin.
    "et-test.PseudoUserTerminal bounds HUP-ignoring shell termination"
  ];

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

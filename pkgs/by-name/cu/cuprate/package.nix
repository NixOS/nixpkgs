{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  patchelf,
  stdenv,
}:

let
  rev = "857af95c043d588e750908f6c6c64d2b13556720";
in
rustPlatform.buildRustPackage {
  pname = "cuprate";
  version = "0.1.0-unstable-2026-10-08";

  src = fetchFromGitHub {
    owner = "Cuprate";
    repo = "cuprate";
    inherit rev;
    hash = "sha256-fPJ0OFn6JgXVYpRozVN8kOHLz1aN6bvp+6ByxxxIORg=";
  };

  # The source archive does not contain Git metadata.
  GITHUB_SHA = rev;

  cargoHash = "sha256-amPnBlziVSChGr4kt0nry6UpfN/HWbnYYwbPKuKGCUM=";

  nativeBuildInputs = [
    cmake
    patchelf
    pkg-config
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  # RandomX invokes CMake from its Cargo build script.
  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "cuprated"
    "--bin"
    "cuprated"
  ];

  # Run cuprated's library unit tests.
  doCheck = true;
  cargoTestFlags = [
    "--package"
    "cuprated"
    "--lib"
  ];

  # RandomX links against the C++ runtime.
  postFixup = ''
    patchelf --add-rpath \
      "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      "$out/bin/cuprated"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/cuprated" -h > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Monero node implementation written in Rust";
    homepage = "https://cuprate.org";
    license = lib.licenses.agpl3Only;
    mainProgram = "cuprated";
    maintainers = [ lib.maintainers.shortwavesurfer2009 ];

    # Initially limit availability to the platform tested so far.
    platforms = [ "x86_64-linux" ];
  };
}

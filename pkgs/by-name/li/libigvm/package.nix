{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-c,
  rust-cbindgen,
  pkg-config,
  cunit,
}:
rustPlatform.buildRustPackage {
  pname = "libigvm";
  version = "0.5.0";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "igvm";
    tag = "igvm-v0.5.0";
    hash = "sha256-2kLYCVtdv1w8vfkv+q7+FcFgN070Na9/F7jVdyamqnU=";
  };
  # from the main branch, v0.5.0 doesn't have the lock file yet
  cargoLock.lockFile = ./Cargo.lock;
  nativeBuildInputs = [
    cargo-c
    rust-cbindgen
    pkg-config
  ];
  buildInputs = [ cunit ];
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
    patchShebangs --build igvm_c/scripts
  '';
  buildPhase = ''
    runHook preBuild
    make -C igvm_c PREFIX="$out" PROFILE="$cargoBuildType" EXTRA_PARAMS="--profile $cargoBuildType" CFLAGS= build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    make -C igvm_c PREFIX="$out" PROFILE="$cargoBuildType" EXTRA_PARAMS="--profile $cargoBuildType" CFLAGS= install
    runHook postInstall
  '';
  checkPhase = ''
    runHook preCheck
    make -C igvm_c PREFIX="$out" PROFILE="$cargoBuildType" EXTRA_PARAMS="--profile $cargoBuildType" CFLAGS= test
    runHook postCheck
  '';

  meta = {
    description = "IGVM C API";
    homepage = "https://github.com/microsoft/igvm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DDoSolitary ];
    platforms = lib.platforms.all;
  };
}

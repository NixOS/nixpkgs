{
  lib,
  rustPlatform,
  fetchCrate,
  cargo-c,
  buildPackages,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "libdovi";
  version = "3.3.1";

  src = fetchCrate {
    pname = "dolby_vision";
    inherit version;
    hash = "sha256-ecd+r0JWZtP/rxt4Y3Cj2TkygXIMy5KZhZpXBwJNPx4=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ cargo-c ];

  buildPhase = ''
    runHook preBuild
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${buildPackages.rust.envVars.setEnv} cargo ctest -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postCheck
  '';

  meta = with lib; {
    description = "C library for Dolby Vision metadata parsing and writing";
    homepage = "https://crates.io/crates/dolby_vision";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}

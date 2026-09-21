{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  buildPackages,
  pkg-config,
  libgit2,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fff-c";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GSjvvdLkuezFUrHqiSeePa64VRb3tabOKZNqEE5XSAw=";
  };

  cargoHash = "sha256-VKI7MnqCGis78qmYuBkViT96ZhG4Wy9vARdnmGV048A=";

  nativeBuildInputs = [
    cargo-c
    pkg-config
  ];

  buildInputs = [
    libgit2
  ];

  env.LIBGIT2_NO_VENDOR = "1";

  buildPhase = ''
    runHook preBuild
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -p fff-c -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -p fff-c -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${buildPackages.rust.envVars.setEnv} cargo ctest -p fff-c -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postCheck
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C library and bindings for the fff file search engine";
    homepage = "https://github.com/dmtrKovalenko/fff";
    changelog = "https://github.com/dmtrKovalenko/fff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bet4it ];
    pkgConfigModules = [ "fff_c" ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "assimp";
  version = "6.0.2";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ixtqK+3iiL17GEbEVHz5S6+gJDDQP7bVuSfRMJMGEOY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "ASSIMP_BUILD_ASSIMP_TOOLS" true)
  ];

  # Some matrix tests fail on non-86_64-linux:
  # https://github.com/assimp/assimp/issues/6246
  # https://github.com/assimp/assimp/issues/6247
  doCheck = !(stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isx86_64);
  checkPhase = ''
    runHook preCheck
    bin/unit
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/assimp/assimp/releases/tag/${finalAttrs.src.tag}";
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  nix-update-script,
}:

let
  inherit (lib) cmakeBool;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "3.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q+7YbDq+BUQklfduc7+Nfgy6XeAWouehfm8Ct7e++os=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # Samples are not installed and would require fetching glfw, imgui, implot and nfd
    (cmakeBool "BOX2D_SAMPLES" false)
    (cmakeBool "BOX2D_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    # b2Hash calls get struct reinterpreted as byte array for input, results not stable across endiannesses
    && stdenv.hostPlatform.isLittleEndian;

  checkPhase = ''
    runHook preCheck

    ./bin/test

    runHook postCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    changelog = "https://github.com/erincatto/box2d/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
})

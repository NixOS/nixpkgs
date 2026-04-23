{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  nasm,
  autoreconfHook,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isa-l_crypto";
  version = "2.25.0";

  src = fetchFromGitHub {
    repo = "isa-l_crypto";
    owner = "intel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vsJr7Sv9SGZDaFnw7793q51ziCpobweCy/LoDfEK5p0=";
  };

  nativeBuildInputs = [
    nasm
    autoreconfHook
  ];

  preConfigure = ''
    export AS=""
  '';

  meta = {
    description = "Collection of optimised low-level functions targeting storage applications with crypto";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/intel/isa-l_crypto";
    changelog = "https://github.com/intel/isa-l_crypto/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.mehrdad ];
    badPlatforms = [
      "aarch64-darwin"
    ];
  };
})

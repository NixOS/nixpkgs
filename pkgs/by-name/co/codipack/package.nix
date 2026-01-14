{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codipack";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "SciCompKL";
    repo = "CoDiPack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dGzLPU8YOrBdXPwUnEElqfxzbUdkAQxtv2+7+itNsyI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast gradient evaluation in C++ based on Expression Templates";
    homepage = "https://scicomp.rptu.de/software/codi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      athas
    ];
  };
})

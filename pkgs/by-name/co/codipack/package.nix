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
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "SciCompKL";
    repo = "CoDiPack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YOQQZG5HSNi+DlRXGL4EPLotp0FhN4qCesGmF8PwTCA=";
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

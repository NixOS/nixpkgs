{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,

  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cohomcalg";
  version = "0.32";

  src = fetchFromGitHub {
    owner = "BenjaminJurke";
    repo = "cohomCalg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9kKKfb8STiCjaHiWgYEQsERNTnOXlwN8axIBJHg43zk=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  patches = [
    (fetchpatch {
      url = "https://github.com/BenjaminJurke/cohomCalg/commit/7aa864b5655c91eb2afc79c419bbf2bf8a4f791b.diff";
      hash = "sha256-JteQ3m2ELmMHaWCN9Sm954KKDn0ax8TywtbQ3dBWk80=";
    })
    ./fix-compilers.patch
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -D bin/cohomcalg $out/bin/cohomcalg
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    mainProgram = "cohomcalg";
    description = "Software package for computation of sheaf cohomologies for line bundles on toric varieties";
    homepage = "https://github.com/BenjaminJurke/cohomCalg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nasm,
  meson,
  ninja,
  pkg-config,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rav1d";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "memorysafety";
    repo = "rav1d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Moj3v7cxPluzNPmOmGhYuz/Qh48BnBjN7Vt4f8aY2o=";
  };

  cargoHash = "sha256-M0j0zgDqElhG3Jgetjx2sL3rxLrShK0zTMmOXwNxBEI=";

  nativeBuildInputs = [
    nasm
  ];

  # Tests are using meson
  # https://github.com/memorysafety/rav1d/tree/v1.0.0?tab=readme-ov-file#running-tests
  nativeCheckInputs = [
    meson
    ninja
    pkg-config
  ];

  checkPhase =
    let
      cargoTarget = rustPlatform.cargoInstallHook.targetSubdirectory;
    in
    ''
      runHook preCheck

      patchShebangs .github/workflows/test.sh
      .github/workflows/test.sh -r target/${cargoTarget}/release/dav1d

      runHook postCheck
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "AV1 cross-platform decoder, Rust port of dav1d";
    homepage = "https://github.com/memorysafety/rav1d";
    changelog = "https://github.com/memorysafety/rav1d/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "dav1d";
  };
})

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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "memorysafety";
    repo = "rav1d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OAfuUeScdjL7xIpf6pclNyo4ugRLIIcTjjf0AwoF+7o=";
  };

  cargoHash = "sha256-13j0++XHcNjkVc3VZxv2ukQvhiu+heZPgaTsA1U4MGQ=";

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

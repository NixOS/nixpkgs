{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  alsa-lib,
  libopus,
  soxr,
  cmake,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (final: {
  pname = "bark";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "haileys";
    repo = "bark";
    tag = "v${final.version}";
    hash = "sha256-JaUIWGCYhasM0DgqL+DiG2rE1OWVg/N66my/4RWDN1E=";
  };

  cargoHash = "sha256-LcmX8LbK8UHDDeqwLTFEUuRBv9GgDiCpXP4bmIR3gME=";

  # Broken rustdoc comment
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/haileys/bark/pull/13.patch";
      hash = "sha256-cA1bqc7XhJ2cxOYvjIJ9oopzBZ9I4rGERkiwDAUh3V4";
    })
  ];

  buildInputs = [
    alsa-lib
    libopus
    soxr
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live sync audio streaming for local networks";
    homepage = "https://github.com/haileys/bark";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.linux;
    mainProgram = "bark";
  };
})

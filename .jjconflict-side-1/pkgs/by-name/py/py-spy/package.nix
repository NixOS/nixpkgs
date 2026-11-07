{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # buildInputs
  libunwind,
  xz,

  # tests
  python3,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

let
  # https://github.com/benfred/py-spy/blob/v0.4.2/build.rs#L6-L8
  supportsUnwind =
    stdenv.hostPlatform.isWindows && stdenv.hostPlatform.isx86_64
    || stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isx86_64);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "py-spy";
  version = "0.4.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5T6R2Neslw8rNYWJbXncLH78kH1o42fR6kidhip6/Bg=";
  };

  cargoHash = "sha256-ZhtQjX15pZe3CM898LBj/79kXa6ESgPOSFkNghq0Ywo=";

  buildFeatures = lib.optionals supportsUnwind [
    "unwind"
  ];

  # https://github.com/benfred/remoteprocess/blob/v0.5.2/build.rs
  buildInputs = lib.optionals (supportsUnwind && stdenv.hostPlatform.isLinux) [
    libunwind
    (lib.getLib xz)
  ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    (python3.withPackages (ps: [ ps.numpy ]))
  ];

  checkFlags = [
    # thread 'test_thread_names' (3078) panicked at tests/integration_test.rs:159:53:
    # called `Option::unwrap()` on a `None` value
    "--skip=test_thread_names"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sampling profiler for Python programs";
    mainProgram = "py-spy";
    homepage = "https://github.com/benfred/py-spy";
    changelog = "https://github.com/benfred/py-spy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})

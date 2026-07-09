{
  lib,
  stdenv,
  fetchFromGitHub,
  libunwind,
  python3,
  rustPlatform,
  xz,
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

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5T6R2Neslw8rNYWJbXncLH78kH1o42fR6kidhip6/Bg=";
  };

  cargoHash = "sha256-ZhtQjX15pZe3CM898LBj/79kXa6ESgPOSFkNghq0Ywo=";

  buildFeatures = lib.optional supportsUnwind "unwind";

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

  meta = {
    description = "Sampling profiler for Python programs";
    mainProgram = "py-spy";
    homepage = "https://github.com/benfred/py-spy";
    changelog = "https://github.com/benfred/py-spy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

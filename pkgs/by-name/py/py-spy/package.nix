{
  lib,
  stdenv,
  fetchFromGitHub,
  libunwind,
  python3,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "py-spy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "benfred";
    repo = "py-spy";
    rev = "v${version}";
    hash = "sha256-T96F8xgB9HRwuvDLXi6+lfi8za/iNn1NAbG4AIpE0V0=";
  };

  cargoHash = "sha256-velwX7lcNQvwg3VAUTbgsOPLlA5fAcPiPvczrBBsMvs=";

  buildFeatures = [ "unwind" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    python3
  ];

  env.NIX_CFLAGS_COMPILE = "-L${libunwind}/lib";

  checkFlags = [
    # assertion `left == right` failed
    "--skip=test_negative_linenumber_increment"
  ];

  meta = {
    description = "Sampling profiler for Python programs";
    mainProgram = "py-spy";
    homepage = "https://github.com/benfred/py-spy";
    changelog = "https://github.com/benfred/py-spy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lnl7 ];
    platforms = lib.platforms.linux;
    # https://github.com/benfred/py-spy/pull/330
    broken = stdenv.hostPlatform.isAarch64;
  };
}

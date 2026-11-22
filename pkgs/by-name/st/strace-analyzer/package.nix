{
  lib,
  rustPlatform,
  fetchFromGitHub,
  strace,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "strace-analyzer";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "wookietreiber";
    repo = "strace-analyzer";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KbdQeZoWFz4D5txu/411J0HNnIAs3t5IvO30/34vBek=";
  };

  cargoHash = "sha256-ZvbWJSe/jQEswcdFM/Akb6hW/0iqMNbtEyzcxsbemFQ=";

  nativeCheckInputs = [ strace ];

  checkFlags = lib.optionals stdenv.hostPlatform.isAarch64 [
    # thread 'analysis::tests::analyze_dd' panicked at 'assertion failed: ...'
    "--skip=analysis::tests::analyze_dd"
  ];

  meta = {
    description = "Analyzes strace output";
    mainProgram = "strace-analyzer";
    homepage = "https://github.com/wookietreiber/strace-analyzer";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pid1";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "pid1-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2dnQj3AQxedyq1YvHKt+lVXNEtuB5sMRSCqX9YeifzI=";
  };

  cargoHash = "sha256-ldHtmbLoSFVxb0B3Oj21UOFNSXwu8xAPhpE8jBqOwr4=";

  meta = {
    description = "Signal handling and zombie reaping for PID1 process";
    homepage = "https://github.com/fpco/pid1-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "pid1";
  };
})

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GIq0LjDF6dyXqU6yMTY2+56lF/UkdZFtnwpNG0k7Ic0=";
  };

  npmDepsHash = "sha256-gVrmuUUwAzCc1/cBrmt9nXyxfIncIj+RyCVsrqXGgVs=";

  meta = {
    description = "Lightweight emulator of iOS HomeKit API";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})

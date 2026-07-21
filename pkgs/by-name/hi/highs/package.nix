{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KmA5B2g3AFCxMbN9gHdXxAEftZglhQKOqj1/TMxxps=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  nativeBuildInputs = [
    clang
    cmake
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/ERGO-Code/HiGHS";
    description = "Linear optimization software";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "highs";
    maintainers = with lib.maintainers; [
      galabovaa
      silky
    ];
  };
})

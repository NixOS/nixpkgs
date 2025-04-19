{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krep";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "davidesantangelo";
    repo = "krep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lg1nwBV/lfPVoMWmVh4iFElr5Qv+YA5HRKZOS3jd+6U=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "ENABLE_ARCH_DETECTION=0"
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Blazingly fast string search utility designed for performance-critical applications";
    homepage = "https://github.com/davidesantangelo/krep";
    changelog = "https://github.com/davidesantangelo/krep/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      codebam
    ];
    platforms = lib.platforms.unix;
  };
})

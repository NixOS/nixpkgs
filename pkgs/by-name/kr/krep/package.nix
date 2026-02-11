{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krep";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "davidesantangelo";
    repo = "krep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yPrQwztqJQGWk/RFklsA3dnuk7GCflaF0WbTm0mx7Gw=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "ENABLE_ARCH_DETECTION=0"
    "HAS_AVX512=0"
    "HAS_AVX2=0"
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

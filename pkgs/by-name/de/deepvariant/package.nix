{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deepvariant";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "deepvariant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8oztrgvBpuI4G1ZFO6yPhb7/HDTJDnplab6ZFOK2SM=";
  };

  meta = {
    description = "Analysis pipeline that uses a deep neural network to call genetic variants from next-generation DNA sequencing data";
    homepage = "https://github.com/google/deepvariant";
    changelog = "https://github.com/google/deepvariant/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "deepvariant";
    platforms = lib.platforms.all;
  };
})

{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.11";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EzzDuzPAyNkL2tFWre86U+kx3SvLPbWto2/vfLdwHGI=";
  };

  lockFile = ./lock.json;

  nativeBuildInputs = [ versionCheckHook ];

  nimFlags = [ ''--passC:"-Wno-incompatible-pointer-types"'' ];

  doInstallCheck = true;

  meta = {
    description = "Fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    mainProgram = "mosdepth";
    license = lib.licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with lib.maintainers; [
      jbedo
      ehmry
    ];
    platforms = lib.platforms.linux;
  };
})

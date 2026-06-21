{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.14";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QnUobAXf0Nc7817+4pmDtYOoQgnIjQ7UburTl6JwMGw=";
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
    ];
    platforms = lib.platforms.linux;
  };
})

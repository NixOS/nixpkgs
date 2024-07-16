{ lib, buildNimPackage, fetchFromGitHub, pcre, versionCheckHook }:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.8";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IkCLlIugnOO2LpS79gakURvPR1ZuayFtrOOoPyNKLMQ=";
  };

  lockFile = ./lock.json;

  buildInputs = [ pcre ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    mainProgram = "mosdepth";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
})

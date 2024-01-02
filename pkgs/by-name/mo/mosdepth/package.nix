{ lib, buildNimPackage, fetchFromGitHub, pcre, testers }:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.5";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tG3J51PS6A0WBCZ+j/Nf7aaukFV+DZJsxpbTbvwu0zc=";
  };

  lockFile = ./lock.json;

  buildInputs = [ pcre ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
})

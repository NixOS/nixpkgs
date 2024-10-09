{ lib, buildNimPackage, fetchFromGitHub, pcre, testers }:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.9";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vHJgIo9qO/L1lZ9DqgXVwv9Pn/6ZMOBfPsY4DEAEImI=";
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
    mainProgram = "mosdepth";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
})

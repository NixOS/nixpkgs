{ lib, buildNimPackage, fetchFromGitHub, pcre, testers }:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.7";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-VyEZNY/P3BfJ3PCRn7R+37XH4gfc9JEOFB0WmrSxpIc=";
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

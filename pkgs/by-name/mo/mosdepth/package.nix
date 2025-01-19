{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  pcre,
  testers,
}:

buildNimPackage (finalAttrs: {
  pname = "mosdepth";
  version = "0.3.10";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RAE3k2yA2zsIr5JFYb5bPaMzdoEKms7TKaqVhPS5LzY=";
  };

  lockFile = ./lock.json;

  buildInputs = [ pcre ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    mainProgram = "mosdepth";
    license = lib.licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.linux;
  };
})

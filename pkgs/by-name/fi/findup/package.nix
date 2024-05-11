{ lib
, stdenv
, fetchFromGitHub
, testers
, zig
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "booniepepper";
    repo = "findup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tpyiy5oJQ04lqVEOFshFC0+90VoNILQ+N6Dd7lbuH/Q=";
  };

  nativeBuildInputs = [ zig.hook ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/booniepepper/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "findup";
  };
})

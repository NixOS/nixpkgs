{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  zig_0_14,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "booniepepper";
    repo = "findup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZrwEOWoXo1RnujroQDGAv4vqRD0ZSyzo8MEnIbHFrY4=";
  };

  nativeBuildInputs = [ zig_0_14.hook ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/booniepepper/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "findup";
  };
})

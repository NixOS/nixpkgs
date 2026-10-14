{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  zig_0_15,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "so-dang-cool";
    repo = "findup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6/rQ4xNfzJQwJgrpvFRuirqlx6fVn7sLXfVRFsG3fUw=";
  };

  nativeBuildInputs = [ zig ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/so-dang-cool/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "findup";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  zig_0_11,
  apple-sdk_11,
}:
let
  zig = zig_0_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "booniepepper";
    repo = "findup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EjfKNIYJBXjlKFNV4dJpOaXCfB5PUdeMjl4k1jFRfG0=";
  };

  nativeBuildInputs = [ zig.hook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://github.com/booniepepper/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "findup";
  };
})

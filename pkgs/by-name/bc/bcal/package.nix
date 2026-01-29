{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  bc,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcal";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PleWU2yyJzkUAZEvEYoCGdpEXqOgRvZK9zXTYrxRtQU=";
  };

  buildInputs = [ readline ];

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  nativeCheckInputs = [
    bc
    python3Packages.pytestCheckHook
  ];

  enabledTestPaths = [ "test.py" ];

  meta = {
    description = "Storage conversion and expression calculator";
    mainProgram = "bcal";
    homepage = "https://github.com/jarun/bcal";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

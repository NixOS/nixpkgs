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
  version = "2.6";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jub6nzol5Wmt/B8U5jmuyTHEKnsg3N28zDjWn/wRhOY=";
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

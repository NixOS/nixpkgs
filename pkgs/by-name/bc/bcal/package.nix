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
  version = "2.5";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6oJEinw9KmZSinMl0s94oWiNshKsEp9HMUvWl12kLP4=";
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

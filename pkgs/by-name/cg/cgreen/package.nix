{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgreen";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "cgreen-devs";
    repo = "cgreen";
    rev = finalAttrs.version;
    sha256 = "sha256-/D06k4c6xu9bL8z/DGnOLvgzOstTeR9PxW/J6a42rZs=";
  };

  postPatch = ''
    for F in tools/discoverer_acceptance_tests.c tools/discoverer.c; do
      substituteInPlace "$F" --replace "/usr/bin/nm" "nm"
    done
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/cgreen-devs/cgreen";
    description = "Modern Unit Test and Mocking Framework for C and C++";
    mainProgram = "cgreen-runner";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

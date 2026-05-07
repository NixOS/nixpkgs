{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  withPython ? false,
  python ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clingo";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "clingo";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-VhfWGAcrq4aN5Tgz84v7vLOWexsA89vRaang58SXVyI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    if withPython then
      [
        "-DCLINGO_BUILD_WITH_PYTHON=ON"
        "-DPYTHON_EXECUTABLE=${lib.getExe python.pythonOnBuildForHost}"
      ]
    else
      [ "-DCLINGO_BUILD_WITH_PYTHON=OFF" ];

  propagatedBuildInputs = lib.optionals withPython (
    with python.pkgs;
    [
      python
      cffi
    ]
  );

  pythonImportsCheck = [
    "clingo"
  ];

  meta = {
    description = "ASP system to ground and solve logic programs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingo/releases/";
  };
})

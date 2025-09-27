{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  cmake,
  ninja,
  nix-update-script,
}:

let
  pyEnv = python3.withPackages (ps: [
    ps.setuptools
    ps.tomli
    ps.pip
    ps.setuptools
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lief";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lief-project";
    repo = "LIEF";
    tag = finalAttrs.version;
    hash = "sha256-icwRW9iY/MiG/x3VHqRfAU2Yk4q2hXLJsfN5Lwx37gw=";
  };

  outputs = [
    "out"
    "py"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  # Not in propagatedBuildInputs because only the $py output needs it; $out is
  # just the library itself (e.g. C/C++ headers).
  buildInputs = with python3.pkgs; [
    python
    build
    pathspec
    pip
    pydantic
    scikit-build-core
  ];

  cmakeFlags = [
    (lib.cmakeBool "LIEF_PYTHON_API" true)
    (lib.cmakeBool "LIEF_EXAMPLES" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  postBuild = ''
    pushd ../api/python
    ${pyEnv.interpreter} -m build --no-isolation --wheel --skip-dependency-check --config-setting=--parallel=$NIX_BUILD_CORES
    popd
  '';

  postInstall = ''
    pushd ../api/python
    ${pyEnv.interpreter} -m pip install --prefix $py dist/*.whl
    popd
  '';

  pythonImportsCheck = [ "lief" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library to Instrument Executable Formats";
    homepage = "https://lief.quarkslab.com/";
    license = [ licenses.asl20 ];
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [
      lassulus
      genericnerdyusername
    ];
  };
})

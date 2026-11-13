{
  lib,
  pythonPackages,
  fetchFromGitHub,
  fetchNpmDeps,
  mopidy,
  nodejs,
  npmHooks,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-iris";
  version = "3.70.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaedb";
    repo = "Iris";
    tag = finalAttrs.version;
    hash = "sha256-Fc0LktN8pCRnrvk9uudXu10J3XfrRbdGlcDKXFNQzmQ=";
  };

  postPatch = ''
    # turn off Google Analytics per default
    substituteInPlace src/js/store/index.js \
      --replace-fail 'allow_reporting: true' 'allow_reporting: false'
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-aQHq80SLaOPOANYV+aDTWC/bxfc1it5iDeRJ8L5iuEU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    npm run prod
  '';

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.configobj
    pythonPackages.requests
    pythonPackages.tornado
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "mopidy_iris" ];

  meta = {
    homepage = "https://github.com/jaedb/Iris";
    description = "Fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rvolosatovs ];
  };
})

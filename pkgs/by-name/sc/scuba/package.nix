{
  lib,
  pkgsStatic,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "scuba";
  version = "2.14.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "JonathonReinhart";
    repo = "scuba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kYr7JyrwDDMJkazZ1cMZNkLo19stnOtc/gSp3nRWAuU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    argcomplete
    pyyaml
  ];

  postPatch = ''
    # Version detection fails
    # Patch in the version instead
    substituteInPlace scuba/version.py \
      --replace-fail "__version__ = get_version()" "__version__ = \"${finalAttrs.version}\""

    # Disable calling cargo through the make file
    # scubainit has already been built
    substituteInPlace setup.py \
      --replace-fail "check_call([\"make\"])" "pass"
  '';

  meta = {
    description = "Simple Container-Utilizing Build Apparatus";
    homepage = "https://github.com/JonathonReinhart/scuba";
    changelog = "https://github.com/JonathonReinhart/scuba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tbaldwin ];
    mainProgram = "scuba";
  };
})

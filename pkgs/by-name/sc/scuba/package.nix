{
  lib,
  pkgsStatic,
  fetchFromGitHub,
  python3Packages,
}:

let
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "JonathonReinhart";
    repo = "scuba";
    tag = "v${version}";
    hash = "sha256-AbaBTI/gz5lifjMx00sxuUl1MxhYM93iKfGdpHsLjzk=";
  };

  # This must be built statically because scuba will execute unknown docker environments
  scubainit = pkgsStatic.rustPlatform.buildRustPackage rec {
    pname = "scubainit";
    inherit src version;

    sourceRoot = "${src.name}/scubainit";

    cargoHash = "sha256-YUYo2B5hzzmDeNiWUC+198Qbz+JPgUJfpAqyPWAXTRA=";
  };
in
python3Packages.buildPythonPackage rec {
  pname = "scuba";
  inherit src version;
  pyproject = true;

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
      --replace-fail "__version__ = get_version()" "__version__ = \"${version}\""

    # Disable calling cargo through the make file
    # scubainit has already been built
    substituteInPlace setup.py \
      --replace-fail "check_call([\"make\"])" "pass"
  '';

  preBuild = ''
    # Link scubainit into the build tree
    ln -s ${scubainit}/bin/scubainit scuba/scubainit
  '';

  meta = {
    description = "Simple Container-Utilizing Build Apparatus";
    homepage = "https://github.com/JonathonReinhart/scuba";
    changelog = "https://github.com/JonathonReinhart/scuba/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tbaldwin ];
    mainProgram = "scuba";
  };
}

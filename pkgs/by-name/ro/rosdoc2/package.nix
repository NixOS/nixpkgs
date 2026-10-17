{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rosdoc2";
  version = "0.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rosdoc2";
    tag = finalAttrs.version;
    hash = "sha256-+D2R7RodN3zMimTa+EIlmL8KIM1LNIKn2hxzwcDaPuo=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.breathe
    python3Packages.catkin-pkg
    python3Packages.exhale
    python3Packages.jinja2
    python3Packages.osrf-pycommon
    python3Packages.pyyaml
    python3Packages.setuptools # Yes, this is required at runtime
    python3Packages.sphinx
    python3Packages.sphinx-rtd-theme
    python3Packages.myst-parser
  ];

  pythonImportsCheck = [
    "rosdoc2"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for generating documentation for ROS 2 packages";
    homepage = "https://github.com/ros-infrastructure/rosdoc2";
    changelog = "https://github.com/ros-infrastructure/rosdoc2/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "rosdoc2";
  };
})

{
  lib,
  gitUpdater,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nile";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/C4b8wPKWHGgiheuAN7AvU+KcD5aj5i6KzgFSdTIkNI=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    setuptools
    requests
    protobuf
    pycryptodome
    zstandard
    json5
    platformdirs
  ];

  pyprojectAppendix = ''
    [tool.setuptools.packages.find]
    include = ["nile*"]
  '';

  postPatch = ''
    echo "$pyprojectAppendix" >> pyproject.toml
  '';

  pythonImportsCheck = [ "nile" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Unofficial Amazon Games client";
    homepage = "https://github.com/imLinguin/nile";
    changelog = "https://github.com/imLinguin/nile/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    mainProgram = "nile";
    maintainers = [ ];
  };
})

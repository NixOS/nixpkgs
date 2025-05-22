{
  lib,
  gitUpdater,
  python3Packages,
  fetchFromGitHub,
}:

let
  version = "1.1.2";
in
python3Packages.buildPythonApplication {
  pname = "nile";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    rev = "v${version}";
    hash = "sha256-/C4b8wPKWHGgiheuAN7AvU+KcD5aj5i6KzgFSdTIkNI=";
  };

  disabled = python3Packages.pythonOlder "3.8";

  propagatedBuildInputs = with python3Packages; [
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

  meta = with lib; {
    description = "Unofficial Amazon Games client";
    mainProgram = "nile";
    homepage = "https://github.com/imLinguin/nile";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ aidalgol ];
  };

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };
}

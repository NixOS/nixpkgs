{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication {
  pname = "comet-gog";
  version = "unstable-2023-12-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    rev = "17cc4a739de0f25e06fbaaca06047207b5048b94";
    hash = "sha256-QXNHTSsz93VM7u4yWtX5oKQb4ZpFgIqnj7rXyXohDEM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3.pkgs; [
    protobuf
    aiohttp
  ];

  meta = {
    description = "Open Source implementation of GOG Galaxy's Communication Service";
    homepage = "https://github.com/imLinguin/comet";
    license = lib.licenses.gpl3Plus;
    mainProgram = "comet";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

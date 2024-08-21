{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "music-assistant-frontend";
  version = "2.8.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L7ASmYtJja+Hy4MnGrNWIwSjvhfq2iXfWm4gGKAnEec=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "~=" ">="
  '';

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "music_assistant_frontend" ];

  meta = with lib; {
    changelog = "https://github.com/music-assistant/frontend/releases/tag/${version}";
    description = "The Music Assistant frontend";
    homepage = "https://github.com/music-assistant/frontend";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}

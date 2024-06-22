{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "music-assistant-frontend";
  version = "2.5.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Cy8jb8iXd/F2+5UsbIliGV/REFVTl6LLxOlN/xVP6U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "~=" ">="
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "music_assistant_frontend" ];

  meta = with lib; {
    description = "The Music Assistant frontend";
    homepage = "https://pypi.org/project/music-assistant-frontend/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

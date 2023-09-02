{ lib
, buildPythonPackage
, fetchFromGitHub
, pdm-backend
, more-itertools
, click
}:

buildPythonPackage rec {
  pname = "hyprshade";
  version = "0.9.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    rev = "refs/tags/v${version}";
    hash = "sha256-ou072V9nZUqf5DEolkMQy979SjaZs4iOuoszw50k4Y8=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [ more-itertools click ];

  meta = with lib; {
    homepage = "https://github.com/loqusion/hyprshade";
    description = "Hyprland shade configuration tool";
    license = licenses.mit;
    maintainers = with maintainers; [ willswats ];
    platforms = platforms.linux;
  };
}

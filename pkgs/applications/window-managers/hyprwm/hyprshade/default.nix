{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, more-itertools
, click
}:

buildPythonPackage rec {
  pname = "hyprshade";
  version = "3.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    rev = "refs/tags/${version}";
    hash = "sha256-bNgXnN4F9kzbi1vTuBqn8H7A8QMznr7QA65eNLumkAA=";
  };

  nativeBuildInputs = [
    hatchling
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

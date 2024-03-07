{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, more-itertools
, click
}:

buildPythonPackage rec {
  pname = "hyprshade";
  version = "3.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    rev = "refs/tags/${version}";
    hash = "sha256-bH+QXvZ+Yaogcp/MYJopiAUvM/imNrSo+cotTzzdlV8=";
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

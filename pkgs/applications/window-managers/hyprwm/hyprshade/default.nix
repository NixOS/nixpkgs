{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, more-itertools
, click
}:

buildPythonPackage rec {
  pname = "hyprshade";
  version = "3.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    rev = "refs/tags/${version}";
    hash = "sha256-vX1Cc170ifevn1aji5s0MI7G0zktPuvSpAbYpGPMudA=";
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

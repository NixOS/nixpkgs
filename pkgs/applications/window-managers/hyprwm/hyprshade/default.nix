{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  more-itertools,
  click,
  hyprland,
  makeWrapper,
}:

buildPythonPackage rec {
  pname = "hyprshade";
  version = "3.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    rev = "refs/tags/${version}";
    hash = "sha256-MlbNE9n//Qb6OJc3DMkOpnPtoodfV8JlG/I5rOfWMtQ=";
  };

  nativeBuildInputs = [
    hatchling
    makeWrapper
  ];

  propagatedBuildInputs = [
    more-itertools
    click
  ];

  postFixup = ''
    wrapProgram $out/bin/hyprshade \
      --set HYPRSHADE_SHADERS_DIR $out/share/hyprshade/shaders \
      --prefix PATH : ${lib.makeBinPath [ hyprland ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/loqusion/hyprshade";
    description = "Hyprland shade configuration tool";
    mainProgram = "hyprshade";
    license = licenses.mit;
    maintainers = with maintainers; [ willswats ];
    platforms = platforms.linux;
  };
}

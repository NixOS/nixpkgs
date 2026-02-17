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
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    tag = version;
    hash = "sha256-zK8i2TePJ4cEtGXe/dssHWg+ioCTo1NyqzInQhMaB8w=";
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

  meta = {
    homepage = "https://github.com/loqusion/hyprshade";
    description = "Hyprland shade configuration tool";
    mainProgram = "hyprshade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ willswats ];
    platforms = lib.platforms.linux;
  };
}

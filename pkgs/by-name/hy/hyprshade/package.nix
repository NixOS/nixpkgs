{
  lib,
  python3Packages,
  fetchFromGitHub,
  hyprland,
  makeWrapper,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "hyprshade";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    tag = finalAttrs.version;
    hash = "sha256-zK8i2TePJ4cEtGXe/dssHWg+ioCTo1NyqzInQhMaB8w=";
  };

  nativeBuildInputs = [
    python3Packages.hatchling
    makeWrapper
  ];

  propagatedBuildInputs = with python3Packages; [
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
})

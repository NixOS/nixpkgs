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
<<<<<<< HEAD
  version = "4.0.1";
=======
  version = "4.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-zK8i2TePJ4cEtGXe/dssHWg+ioCTo1NyqzInQhMaB8w=";
=======
    hash = "sha256-NnKhIgDAOKOdEqgHzgLq1MSHG3FDT2AVXJZ53Ozzioc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/loqusion/hyprshade";
    description = "Hyprland shade configuration tool";
    mainProgram = "hyprshade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ willswats ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://github.com/loqusion/hyprshade";
    description = "Hyprland shade configuration tool";
    mainProgram = "hyprshade";
    license = licenses.mit;
    maintainers = with maintainers; [ willswats ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

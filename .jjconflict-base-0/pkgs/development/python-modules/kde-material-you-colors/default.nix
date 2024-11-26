{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  dbus-python,
  numpy,
  pillow,
  materialyoucolor,
}:

buildPythonPackage rec {
  pname = "kde-material-you-colors";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    rev = "refs/tags/v${version}";
    hash = "sha256-hew+aWbfWmqTsxsNx/0Ow0WZAVl0e6OyzDxcKm+nlzQ=";
  };

  build-system = [ setuptools ];
  dependencies = [
    dbus-python
    numpy
    pillow
    materialyoucolor
  ];

  pythonImportsCheck = [ "kde_material_you_colors" ];

  doCheck = false; # no unittests, and would require KDE desktop environment

  meta = {
    homepage = "https://store.kde.org/p/2136963";
    description = "Automatic color scheme generator from your wallpaper for KDE Plasma powered by Material You";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "kde-material-you-colors";
  };
}

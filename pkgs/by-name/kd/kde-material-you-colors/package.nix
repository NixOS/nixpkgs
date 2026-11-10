{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "kde-material-you-colors";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sN7u3jePevJnTHhQL6eAYKU2AD2QNW7VYuEHLN5RsK8=";
  };

  patches = [
    ./fix-warning.patch
  ];

  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    dbus-python
    numpy
    pillow
    materialyoucolor
    python-magic
    pywal16
  ];

  postInstall = ''
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.kdematerialyou.colors
    cp -r src/plasmoid/package/* $out/share/plasma/plasmoids/luisbocanegra.kdematerialyou.colors
  '';

  pythonImportsCheck = [ "kde_material_you_colors" ];

  doCheck = false; # no unittests, and would require KDE desktop environment

  meta = {
    homepage = "https://store.kde.org/p/2136963";
    description = "Automatic color scheme generator from your wallpaper for KDE Plasma powered by Material You";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      issai
      baksa
    ];
    mainProgram = "kde-material-you-colors";
  };
})

{
  python3,
  lib,
  fetchFromGitHub,
  cinnamon-translations,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nemo-emblems";
  version = "6.7.0";
  pyproject = true;

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = "${finalAttrs.version}-unstable";
    hash = "sha256-msmy//e15B6lYLfsqqUhPAYt/PK+c4k6piY7pw4eqkI=";
  };

  sourceRoot = "${finalAttrs.src.name}/nemo-emblems";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/share" "share"

    substituteInPlace nemo-extension/nemo-emblems.py \
      --replace-fail "/usr/share/locale" "${cinnamon-translations}/share/locale"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-emblems";
    description = "Change a folder or file emblem in Nemo";
    longDescription = ''
      Nemo extension that allows you to change folder or file emblems.
      When adding this to nemo-with-extensions you also need to add nemo-python.
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})

{ python3
, lib
, fetchFromGitHub
, cinnamon-translations
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nemo-emblems";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = "nemo-emblems-${version}";
    hash = "sha256-HfWZntG+SHrzkN4fa3qYj9+fM6zF32qFquL/InoUi/k=";
  };

  format = "setuptools";

  sourceRoot = "${src.name}/nemo-emblems";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/share" "share"

    substituteInPlace nemo-extension/nemo-emblems.py \
      --replace "/usr/share/locale" "${cinnamon-translations}/share/locale"
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-emblems";
    description = "Change a folder or file emblem in Nemo";
    longDescription = ''
      Nemo extension that allows you to change folder or file emblems.
      When adding this to nemo-with-extensions you also need to add nemo-python.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}

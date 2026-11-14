{
  python3,
  pkgs,
  lib,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nemo-compare";
  version = "6.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = finalAttrs.version;
    hash = "sha256-tXeMkaCYnWzg+6ng8Tyg4Ms1aUeE3xiEkQ3tKEX6Vv8=";
  };

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook3
    gobject-introspection
  ];

  sourceRoot = "${finalAttrs.src.name}/nemo-compare";

  build-system = with python3.pkgs; [ setuptools ];

  prePatch = ''
    sed -i "s:/usr/share:share:" setup.py
    sed -i "s:/usr/bin:bin:" setup.py
    sed -i "s:/usr/share:$out/share:" src/nemo-compare-preferences
    sed -i "s:/usr/share:$out/share:" src/nemo-compare.py
    sed -i "s:\['/usr/bin', '/usr/local/bin'\]:\['/run/current-system/sw/bin/', '/usr/bin', '/usr/local/bin'\]:" src/utils.py
    sed -i "s@import sys:@import sys:\nsys.path += '${
      python3.pkgs.makePythonPath [ python3.pkgs.pygobject3 ]
    }'.split(os.pathsep)@" src/nemo-compare.py
    sed -i "s@import os@import os\nimport sys\nsys.path += '${
      python3.pkgs.makePythonPath [ python3.pkgs.pygobject3 ]
    }'.split(os.pathsep)@" src/nemo-compare-preferences.py
  '';

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-compare";
    description = "Context menu comparison extension for Nemo file manager";
    longDescription = ''
      Context menu comparison extension for Nemo file manager
      When adding this to nemo-with-extensions, you also need to add nemo-python,
      and a file comparison tool like meld. See the [debian control file for supported comparison tools](https://github.com/linuxmint/nemo-extensions/blob/master/nemo-compare/debian/control)
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ denperidge ];
  };
})

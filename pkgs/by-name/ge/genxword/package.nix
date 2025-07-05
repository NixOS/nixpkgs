{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
  gobject-introspection,
  wrapGAppsHook3,
  pango,
  gtksourceview3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "genxword";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "riverrun";
    repo = "genxword";
    rev = "v${version}";
    sha256 = "17h8saja45bv612yk0pra9ncbp2mjnx5n10q25nqhl765ks4bmb5";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    pango
    gtksourceview3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pycairo
    pygobject3
  ];

  # to prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # there are no tests
  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Crossword generator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

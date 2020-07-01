{ lib
, python3
, fetchFromGitHub
, gettext
, gobject-introspection
, wrapGAppsHook
, pango
, gtksourceview3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "genxword";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "riverrun";
    repo = pname;
    rev = "v${version}";
    sha256 = "00czdvyb5wnrk3x0g529afisl8v4frfys9ih0nzf1fs4jkzjcijg";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
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

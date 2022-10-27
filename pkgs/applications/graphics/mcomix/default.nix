{ lib
, fetchurl
, gdk-pixbuf
, gobject-introspection
, gtk3
, mcomix
, python3
, testers
, wrapGAppsHook

# Recommended Dependencies:
, lhasa
, mupdf
, p7zip
, unrar
, unrarSupport ? false  # unfree software
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcomix";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/mcomix/${pname}-${version}.tar.gz";
    sha256 = "sha256-7zjQcT5WoHxy+YzCDJ6s2ngOOfO4L9exuqBqacecClg=";
  };

  buildInputs = [ gobject-introspection gtk3 gdk-pixbuf ];
  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = (with python3.pkgs; [ pillow pygobject3 pycairo ]);

  # Tests are broken
  doCheck = false;

  # Correct wrapper behavior, see https://github.com/NixOS/nixpkgs/issues/56943
  # until https://github.com/NixOS/nixpkgs/pull/102613
  strictDeps = false;

  # prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${lib.makeBinPath ([ p7zip lhasa mupdf ] ++ lib.optional (unrarSupport) unrar)}"
    )
  '';

  passthru.tests.version = testers.testVersion {
    package = mcomix;
  };

  meta = with lib; {
    description = "Comic book reader and image viewer";
    longDescription = ''
      User-friendly, customizable image viewer, specifically designed to handle
      comic books and manga supporting a variety of container formats
      (including CBR, CBZ, CB7, CBT, LHA and PDF)
    '';
    homepage = "https://sourceforge.net/projects/mcomix/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thiagokokada ];
  };
}

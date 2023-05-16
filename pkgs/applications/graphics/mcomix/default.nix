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
<<<<<<< HEAD
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/mcomix/${pname}-${version}.tar.gz";
    hash = "sha256-fmnlPhNCN6YR3lW2YCMEAbEiWVigcfFDq1tDQ1eTNkA=";
=======
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/mcomix/${pname}-${version}.tar.gz";
    hash = "sha256-Nok4oqTezO84q9IDZvgi33ZeKfRL+tpg7QEDmp2ZZpU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ gtk3 gdk-pixbuf ];
  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
  propagatedBuildInputs = (with python3.pkgs; [ pillow pygobject3 pycairo ]);

  # Tests are broken
  doCheck = false;

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

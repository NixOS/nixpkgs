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
, p7zip
, unrar
, unrarSupport ? false  # unfree software
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcomix";
  version = "3.0.0";
  pyproject = true;

  src = fetchurl {
    url = "mirror://sourceforge/mcomix/mcomix-${version}.tar.gz";
    hash = "sha256-InDEPXXih49k5MiG1bATElxCiUs2RZTV7JeRVMTeoAQ=";
  };

  buildInputs = [
    gtk3
    gdk-pixbuf
  ];

  nativeBuildInputs = [
    gobject-introspection
    python3.pkgs.setuptools
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # Runtime dependencies
    pillow
    pycairo
    pygobject3
    # Optional dependencies
    chardet
    pymupdf
  ];

  # No tests included in .tar.gz
  doCheck = false;

  # Prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${lib.makeBinPath ([ p7zip ] ++ lib.optional unrarSupport unrar)}"
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

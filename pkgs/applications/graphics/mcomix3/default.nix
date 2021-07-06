{ lib
, fetchFromGitHub
, wrapGAppsHook
, installShellFiles
, python3
, gobject-introspection
, gtk3
, gdk-pixbuf

# Recommended Dependencies:
, unrarSupport ? false  # unfree software
, unrar
, p7zip
, lhasa
, mupdf
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcomix3";
  version = "unstable-2021-04-23";

  # no official release on pypi/github and no build system
  src = fetchFromGitHub {
    repo   = "${pname}";
    owner  = "multiSnow";
    rev = "139344e23898c28484328fc29fd0c6659affb12d";
    sha256 = "0q9xgl60ryf7qmy5vgzgfry4rvw5j9rb4d1ilxmpjmvm7dd3fm2k";
  };

  buildInputs = [ gobject-introspection gtk3 gdk-pixbuf ];
  nativeBuildInputs = [ wrapGAppsHook installShellFiles ];
  propagatedBuildInputs = (with python3.pkgs; [ pillow pygobject3 pycairo ]);

  format = "other";

  # Correct wrapper behavior, see https://github.com/NixOS/nixpkgs/issues/56943
  # until https://github.com/NixOS/nixpkgs/pull/102613
  strictDeps = false;

  preInstall = ''
    libdir=$out/lib/${python3.libPrefix}/site-packages
    mkdir -p $out/share/{icons/hicolor,man/man1,applications,metainfo,thumbnailers}
    mkdir -p $out/bin $libdir
  '';

  installPhase = ''
    runHook preInstall

    substituteInPlace mime/*.desktop \
      --replace "Exec=mcomix" "Exec=mcomix3"
    ${python3.executable} installer.py --srcdir=mcomix --target=$libdir
    mv $libdir/mcomix/mcomixstarter.py $out/bin/${pname}
    mv $libdir/mcomix/comicthumb.py $out/bin/comicthumb
    mv $libdir/mcomix/mcomix/* $libdir/mcomix

    runHook postInstall
  '';

  postInstall = ''
    rmdir $libdir/mcomix/mcomix
    mv man/mcomix.1 man/${pname}.1
    installManPage man/*
    cp -r mime/icons/* $out/share/icons/hicolor/
    cp mime/*.desktop $out/share/applications/
    cp mime/*.appdata.xml $out/share/metainfo/
    cp mime/*.thumbnailer $out/share/thumbnailers/
    for folder in $out/share/icons/hicolor/*; do
        mkdir $folder/{apps,mimetypes}
        mv $folder/*.png $folder/mimetypes
        cp $libdir/mcomix/images/$(basename $folder)/mcomix.png $folder/apps/${pname}.png
        cp $folder/mimetypes/application-x-cbt.png $folder/mimetypes/application-x-cbr.png
        cp $folder/mimetypes/application-x-cbt.png $folder/mimetypes/application-x-cbz.png
    done
  '';

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${lib.makeBinPath ([ p7zip lhasa mupdf ] ++ lib.optional (unrarSupport) unrar)}"
    )
  '';

  # real pytests broken upstream
  checkPhase = ''
    $out/bin/comicthumb --help > /dev/null
    $out/bin/${pname} --help > /dev/null
  '';

  meta = with lib; {
    description = "Comic book reader and image viewer; python3 fork of mcomix";
    longDescription = ''
      User-friendly, customizable image viewer, specifically designed to handle
      comic books and manga supporting a variety of container formats
      (including CBR, CBZ, CB7, CBT, LHA and PDF)
    '';
    homepage = "https://github.com/multiSnow/mcomix3";
    changelog = "https://github.com/multiSnow/mcomix3/blob/gtk3/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ confus ];
    platforms = platforms.all;
  };
}

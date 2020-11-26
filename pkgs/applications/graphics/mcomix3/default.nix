{ stdenv
, lib
, fetchFromGitHub
, python3
, wrapGAppsHook
, gobject-introspection
, gtk3
, gdk-pixbuf
# Recommended Dependencies:
, unrarSupport ? false
, unrar
, p7zip
, lhasa
, mupdf
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcomix3";
  version = "unstable-2020-11-23";

  # fetch from github because no official release on pypi/github and no build system
  src = fetchFromGitHub {
    repo   = "${pname}";
    owner  = "multiSnow";
    rev = "cdcb27533dc7ee2ebf7b0a8ab5ba10e61c0b8ff8";
    sha256 = "0q9xgl60ryf7qmy5vgzgfry4rvw5j9rb4d1ilxmpjmvm7dd3fm2k";
  };

  buildInputs = [ gobject-introspection gtk3 gdk-pixbuf ];
  nativeBuildInputs = [ wrapGAppsHook ];
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

    ${python3.executable} installer.py --srcdir=mcomix --target=$libdir
    mv $libdir/mcomix/mcomixstarter.py $out/bin/${pname}
    mv $libdir/mcomix/comicthumb.py $out/bin/comicthumb
    mv $libdir/mcomix/mcomix/* $libdir/mcomix

    runHook postInstall
  '';

  postInstall = ''
    rmdir $libdir/mcomix/mcomix
    cp man/* $out/share/man/man1/
    cp -r mime/icons/* $out/share/icons/hicolor/
    cp mime/*.desktop $out/share/applications/
    cp mime/*.appdata.xml $out/share/metainfo/
    cp mime/*.thumbnailer $out/share/thumbnailers/
    for folder in $out/share/icons/hicolor/*; do
        mkdir $folder/{apps,mimetypes}
        mv $folder/*.png $folder/mimetypes
        cp $folder/mimetypes/application-x-cbt.png $folder/mimetypes/application-x-cbr.png
        cp $folder/mimetypes/application-x-cbt.png $folder/mimetypes/application-x-cbz.png
    done
  '';

  # to prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${lib.makeBinPath ([ p7zip lhasa mupdf ] ++ lib.optional (unrarSupport) unrar)}"
    )
  '';

  # real pytests seem to be broken upstream
  checkPhase = ''
    $out/bin/comicthumb --help > /dev/null
    $out/bin/${pname} --help > /dev/null
  '';

  meta = with stdenv.lib; {
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

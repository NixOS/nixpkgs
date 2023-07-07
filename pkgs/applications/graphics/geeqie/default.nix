{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, xxd, gettext, intltool
, gtk3, lcms2, exiv2, libchamplain, clutter-gtk, ffmpegthumbnailer, fbida
, libarchive, djvulibre, libheif, openjpeg, libjxl, libraw, lua5_3, poppler
, gspell, libtiff, libwebp
, wrapGAppsHook, fetchpatch, doxygen
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "geeqie";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "BestImageViewer";
    repo = "geeqie";
    rev = "v${version}";
    sha256 = "sha256-0GOX77vZ4KZkvwnR1vlv52tlbR+ciwl3ycxbOIcDOqU=";
  };

  postPatch = ''
    patchShebangs .
    # libtiff detection is broken and looks for liblibtiff...
    # fixed upstream, to remove for 2.1
    substituteInPlace meson.build --replace 'libtiff' 'tiff'
  '';

  nativeBuildInputs =
    [ pkg-config gettext intltool
      wrapGAppsHook doxygen
      meson ninja xxd
    ];

  buildInputs = [
    gtk3 lcms2 exiv2 libchamplain clutter-gtk ffmpegthumbnailer fbida
    libarchive djvulibre libheif openjpeg libjxl libraw lua5_3 poppler
    gspell libtiff libwebp
  ];

  postInstall = ''
    # Allow geeqie to find exiv2 and exiftran, necessary to
    # losslessly rotate JPEG images.
    sed -i $out/lib/geeqie/geeqie-rotate \
        -e '1 a export PATH=${lib.makeBinPath [ exiv2 fbida ]}:$PATH'
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Lightweight GTK based image viewer";

    longDescription =
      ''
        Geeqie is a lightweight GTK based image viewer for Unix like
        operating systems.  It features: EXIF, IPTC and XMP metadata
        browsing and editing interoperability; easy integration with other
        software; geeqie works on files and directories, there is no need to
        import images; fast preview for many raw image formats; tools for
        image comparison, sorting and managing photo collection.  Geeqie was
        initially based on GQview.
      '';

    license = licenses.gpl2Plus;

    homepage = "https://www.geeqie.org/";

    maintainers = with maintainers; [ jfrankenau pSub markus1189 ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}

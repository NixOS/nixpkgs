{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, xxd, gettext, intltool
, gtk3, lcms2, exiv2, libchamplain, clutter-gtk, ffmpegthumbnailer, fbida
, libarchive, djvulibre, libheif, openjpeg, libjxl, libraw, lua5_3, poppler
, gspell, libtiff, libwebp
, wrapGAppsHook, fetchpatch, doxygen
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "geeqie";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "BestImageViewer";
    repo = "geeqie";
    rev = "v${version}";
    hash = "sha256-qkM/7auZ9TMF2r8KLnitxmvlyPmIjh7q9Ugh+QKh8hw=";
  };

  patches = [
    (fetchpatch {
      name = "exiv2-0.28.0-support-1.patch";
      url = "https://github.com/BestImageViewer/geeqie/commit/c45cca777aa3477eaf297db99f337e18d9683c61.patch";
      hash = "sha256-YiFzAj3G3Z2w7p+8zZlDBjWqUqnfSqvaxMkESfPFdzc=";
    })
    (fetchpatch {
      name = "exiv2-0.28.0-support-2.patch";
      url = "https://github.com/BestImageViewer/geeqie/commit/b04f7cd0546976dc4f7ea440648ac0eedd8df3ce.patch";
      hash = "sha256-V0ZOHbAZOrhLcNN+Al1/kvxvbw0vc/R7r99CegjuBQg=";
    })
    (fetchpatch {
      name = "fix-compilation-with-lua.patch";
      url = "https://github.com/BestImageViewer/geeqie/commit/a132645ee87e612217ac955b227cad04f21a5722.patch";
      hash = "sha256-BozarBPoIKxZS3qpjuzHHAWZGIWZAwvJyqsNC8v+TMk=";
    })
  ];

  postPatch = ''
    patchShebangs .
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

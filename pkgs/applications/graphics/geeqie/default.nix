{ lib, stdenv, fetchFromGitHub, pkg-config, autoconf, automake, gettext, intltool
, gtk3, lcms2, exiv2, libchamplain, clutter-gtk, ffmpegthumbnailer, fbida
, wrapGAppsHook, fetchpatch, bash, doxygen
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "geeqie";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "BestImageViewer";
    repo = "geeqie";
    rev = "v${version}";
    sha256 = "sha256-Abr7trlms6bxOAqE6xNKRv51TBGNilNdBhUZUg7OTKY=";
  };

  patches = [
    # Do not build the changelog as this requires markdown.
    (fetchpatch {
      name = "geeqie-1.4-goodbye-changelog.patch";
      url = "https://src.fedoraproject.org/rpms/geeqie/raw/132fb04a1a5e74ddb333d2474f7edb9a39dc8d27/f/geeqie-1.4-goodbye-changelog.patch";
      sha256 = "00a35dds44kjjdqsbbfk0x9y82jspvsbpm2makcm1ivzlhjjgszn";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  preConfigure = "./autogen.sh";

  nativeBuildInputs =
    [ pkg-config autoconf automake gettext intltool
      wrapGAppsHook bash doxygen
    ];

  buildInputs = [
    gtk3 lcms2 exiv2 libchamplain clutter-gtk ffmpegthumbnailer fbida
  ];

  postInstall = ''
    # Allow geeqie to find exiv2 and exiftran, necessary to
    # losslessly rotate JPEG images.
    sed -i $out/lib/geeqie/geeqie-rotate \
        -e '1 a export PATH=${lib.makeBinPath [ exiv2 fbida ]}:$PATH'
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
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

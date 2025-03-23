{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,

  autoreconfHook,
  bzip2,
  cfitsio,
  exiv2,
  gettext,
  gtk2,
  gtkimageview,
  lcms2,
  lensfun,
  libjpeg,
  libtiff,
  perl,
  pkg-config,
  zlib,

  addThumbnailer ? false,
}:

stdenv.mkDerivation rec {
  pname = "nufraw";
  version = "0.43-3";

  src = fetchurl {
    url = "mirror://sourceforge/nufraw/nufraw-${version}.tar.gz";
    sha256 = "0b63qvw9r8kaqw36bk3a9zwxc41h8fr6498indkw4glrj0awqz9c";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    perl
    pkg-config
  ];

  buildInputs = [
    bzip2
    cfitsio
    exiv2
    gtk2
    gtkimageview
    lcms2
    lensfun
    libjpeg
    libtiff
    zlib
  ];

  configureFlags = [
    "--enable-contrast"
    "--enable-dst-correction"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  postInstall = lib.optionalString addThumbnailer ''
    mkdir -p $out/share/thumbnailers
    substituteAll ${./nufraw.thumbnailer} $out/share/thumbnailers/${pname}.thumbnailer
  '';

  patches =
    [
      # Fixes an upstream issue where headers with templates were included in an extern-C scope
      # which caused the build to fail
      (fetchpatch {
        name = "0001-nufraw-glib-2.70.patch";
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/gimp-nufraw/-/raw/3405bc864752dbd04f2d182a21b4108d6cc3aa95/0001-nufraw-glib-2.70.patch";
        hash = "sha256-XgzgjikWTcqymHa7bKmruNZaeb2/lpN19HXoRUt5rTk=";
      })
    ]
    ++ lib.optionals (lib.versionAtLeast exiv2.version "0.28") [
      (fetchpatch {
        name = "0002-exiv2-error.patch";
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/gimp-nufraw/-/raw/3405bc864752dbd04f2d182a21b4108d6cc3aa95/0002-exiv2-error.patch";
        hash = "sha256-40/Wwk1sWiaIWp077EYgP8jFO4k1cvf30heRDMYJw3M=";
      })
    ];

  meta = with lib; {
    homepage = "https://nufraw.sourceforge.io/";
    description = "Utility to read and manipulate raw images from digital cameras";
    longDescription = ''
      A new version of the popular raw digital images manipulator ufraw.
      Forks from the version 0.23 of ufraw (that's why the first nufraw version is the 0.24).
      Nufraw offers the same features (gimp plugin, batch, ecc) and the same quality of
      ufraw in a brand new improved user interface.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ asbachb ];
    platforms = platforms.linux;
  };
}

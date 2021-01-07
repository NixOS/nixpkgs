{ stdenv
, fetchurl
, lib

, autoreconfHook
, bzip2
, cfitsio
, exiv2
, gettext
, gtk2
, gtkimageview
, lcms2
, lensfun
, libjpeg
, libtiff
, perl
, pkg-config
, zlib

, addThumbnailer ? false
}:

stdenv.mkDerivation rec {
  pname = "nufraw";
  version = "0.43-3";

  src = fetchurl {
    url = "mirror://sourceforge/nufraw/nufraw-${version}.tar.gz";
    sha256 = "0b63qvw9r8kaqw36bk3a9zwxc41h8fr6498indkw4glrj0awqz9c";
  };

  nativeBuildInputs = [ autoreconfHook gettext perl pkg-config ];

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

  postInstall = lib.optionalString addThumbnailer ''
    mkdir -p $out/share/thumbnailers
    substituteAll ${./nufraw.thumbnailer} $out/share/thumbnailers/${pname}.thumbnailer
  '';

  meta = with stdenv.lib; {
    homepage = "https://nufraw.sourceforge.io/";
    description = "Utility to read and manipulate raw images from digital cameras";
    longDescription =
      ''
        A new version of the popular raw digital images manipulator ufraw.
        Forks from the version 0.23 of ufraw (that's why the first nufraw version is the 0.24).
        Nufraw offers the same features (gimp plugin, batch, ecc) and the same quality of
        ufraw in a brand new improved user interface.
      '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ asbachb ];
    platforms   = [ "x86_64-linux" "i686-linux" ];
  };
}

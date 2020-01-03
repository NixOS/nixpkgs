{ stdenv
, fetchFromGitHub

, autoconf
, automake
, autoreconfHook
, bzip2
, cfitsio
, exiv2
, gettext
, gimp ? null
, gtk2
, gtkimageview
, lcms2
, lensfun
, libjpeg
, libtiff
, perl
, pkgconfig
, zlib

, withGimpPlugin ? true
}:

assert withGimpPlugin -> gimp != null;

stdenv.mkDerivation {
  pname = "ufraw";
  version = "unstable-2019-06-12";

  # The original ufraw repo is unmaintained and broken;
  # this is a fork that collects patches
  src = fetchFromGitHub {
    owner = "sergiomb2";
    repo = "ufraw";
    rev = "c65b4237dcb430fb274e4778afaf5df9a18e04e6";
    sha256 = "02icn67bsinvgliy62qa6v7gmwgp2sh15jvm8iiz3c7g1h74f0b7";
  };

  outputs = [ "out" ] ++ stdenv.lib.optional withGimpPlugin "gimpPlugin";

  nativeBuildInputs = [ autoconf automake autoreconfHook gettext perl pkgconfig ];

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
  ] ++ stdenv.lib.optional withGimpPlugin gimp;

  configureFlags = [
    "--enable-contrast"
    "--enable-dst-correction"
  ] ++ stdenv.lib.optional withGimpPlugin "--with-gimp";

  postInstall = stdenv.lib.optionalString withGimpPlugin ''
    moveToOutput "lib/gimp" "$gimpPlugin"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/sergiomb2/ufraw;

    description = "Utility to read and manipulate raw images from digital cameras";

    longDescription =
      '' The Unidentified Flying Raw (UFRaw) is a utility to read and
         manipulate raw images from digital cameras.  It can be used on its
         own or as a Gimp plug-in.  It reads raw images using Dave Coffin's
         raw conversion utility - DCRaw.  UFRaw supports color management
         workflow based on Little CMS, allowing the user to apply ICC color
         profiles.  For Nikon users UFRaw has the advantage that it can read
         the camera's tone curves.
      '';

    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ gloaming ];
    platforms   = with platforms; all;
  };
}

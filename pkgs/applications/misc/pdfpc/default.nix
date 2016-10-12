{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkgconfig, gnome3
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, librsvg }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.0.2-unstable-2016-09-24";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "b7816ea373d52e178e0784770ce985975a4f7a35";
    sha256 = "17nnqcz4jh8p3r0nidmdc9qz1c9l8jqs07cs16hg2j2g1p343kgx";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ gstreamer gst-plugins-base poppler
                  libpthreadstubs makeWrapper librsvg ]
                ++ (with gnome3; [ vala gtk3 libgee]);

  postInstall = ''
    wrapProgram $out/bin/pdfpc \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    description = "A presenter console with multi-monitor support for PDF files";
    homepage = https://pdfpc.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };

}

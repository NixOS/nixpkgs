{ config, stdenv, fetchFromGitHub, pkgconfig, libconfig
, gtkmm2, glibmm, libxml2, libsecret, curl, libzip
, librsvg, gst_all_1, autoreconfHook, makeWrapper
, useUnrar ? config.ahoviewer.useUnrar or false, unrar
}:

assert useUnrar -> unrar != null;

stdenv.mkDerivation rec {
  pname = "ahoviewer";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "ahodesuka";
    repo = "ahoviewer";
    rev = version;
    sha256 = "1avdl4qcpznvf3s2id5qi1vnzy4wgh6vxpnrz777a1s4iydxpcd8";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = [
    glibmm libconfig gtkmm2 glibmm libxml2
    libsecret curl libzip librsvg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
  ] ++ stdenv.lib.optional useUnrar unrar;

  NIX_LDFLAGS = "-lpthread";

  postPatch = ''patchShebangs version.sh'';

  postInstall = ''
    wrapProgram $out/bin/ahoviewer \
    --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
    --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ahodesuka/ahoviewer;
    description = "A GTK2 image viewer, manga reader, and booru browser";
    maintainers = with maintainers; [ skrzyp xzfc ];
    license = licenses.mit;
    # Unintentionally not working on Darwin:
    # https://github.com/ahodesuka/ahoviewer/issues/62
    platforms = platforms.linux;
  };
}



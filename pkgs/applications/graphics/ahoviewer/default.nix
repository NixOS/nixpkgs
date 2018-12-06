{ stdenv, fetchFromGitHub, pkgconfig, libconfig,
  gtkmm2, glibmm, libxml2, libsecret, curl, libzip,
  librsvg, gst_all_1, autoreconfHook, makeWrapper,
  useUnrar ? false, unrar
}:

assert useUnrar -> unrar != null;

stdenv.mkDerivation rec {
  name = "ahoviewer-${version}";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "ahodesuka";
    repo = "ahoviewer";
    rev = version;
    sha256 = "144jmk8w7dnmqy4w81b3kzama7i97chx16pgax2facn72a92921q";
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



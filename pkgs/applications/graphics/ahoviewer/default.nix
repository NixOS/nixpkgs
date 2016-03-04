{ stdenv, pkgs, fetchurl, fetchFromGitHub, pkgconfig, libconfig, 
  gtkmm, glibmm, libxml2, libsecret, curl, unrar, libzip, 
  librsvg, gst_all_1, autoreconfHook, makeWrapper }:
stdenv.mkDerivation {
  name = "ahoviewer-1.4.6";
  src = fetchFromGitHub {
    owner = "ahodesuka";
    repo = "ahoviewer";
    rev = "414cb91d66d96fab4b48593a7ef4d9ad461306aa";
    sha256 = "081jgfmbwf2av0cn229cf4qyv6ha80ridymsgwq45124b78y2bmb";
  };
  enableParallelBuilding = true; 
  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = [ glibmm libconfig gtkmm glibmm libxml2 
                  libsecret curl unrar libzip librsvg 
                  gst_all_1.gstreamer
                  gst_all_1.gst-plugins-good 
                  gst_all_1.gst-plugins-bad 
                  gst_all_1.gst-libav
                  gst_all_1.gst-plugins-base ];
  postPatch = ''patchShebangs version.sh'';
  postInstall = ''
    wrapProgram $out/bin/ahoviewer \
    --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
    --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';
  meta = {
    homepage = "https://github.com/ahodesuka/ahoviewer";
    description = "A GTK2 image viewer, manga reader, and booru browser";
    maintainers = [ stdenv.lib.maintainers.skrzyp ];
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.allBut [ "darwin" "cygwin" ];
  };
}



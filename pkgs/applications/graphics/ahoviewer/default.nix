{ stdenv, pkgs, fetchurl, fetchFromGitHub, pkgconfig, libconfig, 
  gtkmm2, glibmm, libxml2, libsecret, curl, unrar, libzip,
  librsvg, gst_all_1, autoreconfHook, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ahoviewer-${version}";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "ahodesuka";
    repo = "ahoviewer";
    rev = version;
    sha256 = "0fsak22hpi2r8zqysswdyngaf3n635qvclqh1p0g0wrkfza4dbc4";
  };

  enableParallelBuilding = true; 
  
  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = [ glibmm libconfig gtkmm2 glibmm libxml2
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

  meta = with stdenv.lib; {
    homepage = https://github.com/ahodesuka/ahoviewer;
    description = "A GTK2 image viewer, manga reader, and booru browser";
    maintainers = [ maintainers.skrzyp ];
    license = licenses.mit;
    platforms = platforms.allBut [ "darwin" "cygwin" ];
  };
}



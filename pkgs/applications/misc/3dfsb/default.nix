{ stdenv, makeWrapper, glibc, fetchgit, pkgconfig, SDL, SDL_image, SDL_stretch,
  mesa, mesa_glu, freeglut, gst_all_1, gtk2, file, imagemagick }:

stdenv.mkDerivation {
  name = "3dfsb-1.0";

  meta = with stdenv.lib; {
    description = "3D File System Browser - cleaned up and improved fork of the old tdfsb which runs on GNU/Linux and should also run on BeOS/Haiku and FreeBSD";
    homepage = "https://github.com/tomvanbraeckel/3dfsb";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eduarrrd ];
  };

  src = fetchgit {
    url = "git://github.com/tomvanbraeckel/3dfsb.git";
    rev = "a69a9dfad42acbe2816328d11b58b65f4186c4c5";
    sha256 = "191ndg4vfanjfx4qh186sszyy4pphx3l41rchins9mg8y5rm5ffp";
  };

  buildInputs = with gst_all_1; [ makeWrapper glibc pkgconfig SDL SDL_image SDL_stretch mesa_glu freeglut gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav gtk2 file imagemagick ];

  buildPhase = "sh ./compile.sh";
  dontStrip = true;

  installPhase = "mkdir $out/bin/ && cp 3dfsb $out/bin/";

  preFixup = ''
    wrapProgram $out/bin/3dfsb \
     --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
    '';
}

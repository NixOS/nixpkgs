{ stdenv
, fetchurl
, lib
, vdr
, libcap
, libvdpau
, xine-lib
, libjpeg
, libextractor
, libglvnd
, libGLU
, libX11
, libXext
, libXrender
, libXrandr
, ffmpeg
, avahi
, wayland
, makeWrapper
, dbus-glib
}:
let
  makeXinePluginPath = l: lib.concatStringsSep ":" (map (p: "${p}/lib/xine/plugins") l);

  self = stdenv.mkDerivation rec {
    pname = "vdr-xineliboutput";
    version = "2.3.0";

    src = fetchurl {
      url = "mirror://sourceforge/project/xineliboutput/xineliboutput/${pname}-${version}/${pname}-${version}.tgz";
      sha256 = "sha256-GnTaGaIbBufZP2npa9mAbrO1ccMf1RzhbvjrWhKBTjg=";
    };

    postPatch = ''
      # pkg-config is called with opengl, which do not contain needed glx symbols
      substituteInPlace configure \
        --replace "X11  opengl" "X11  gl"
    '';

    # configure don't accept argument --prefix
    dontAddPrefix = true;

    postConfigure = ''
      sed -i config.mak \
        -e 's,XINEPLUGINDIR=/[^/]*/[^/]*/[^/]*/,XINEPLUGINDIR=/,'
    '';

    makeFlags = [ "DESTDIR=$(out)" ];

    postFixup = ''
      for f in $out/bin/*; do
        wrapProgram $f \
          --prefix XINE_PLUGIN_PATH ":" "${makeXinePluginPath [ "$out" xine-lib ]}"
      done
    '';

    nativeBuildInputs = [ makeWrapper ];

    buildInputs = [
      dbus-glib
      ffmpeg
      libcap
      libextractor
      libjpeg
      libglvnd
      libGLU
      libvdpau
      libXext
      libXrandr
      libXrender
      libX11
      vdr
      xine-lib
      avahi
      wayland
    ];

    passthru.requiredXinePlugins = [ xine-lib self ];

    meta = with lib;{
      homepage = "https://sourceforge.net/projects/xineliboutput/";
      description = "Xine-lib based software output device for VDR";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };
  };
in
self

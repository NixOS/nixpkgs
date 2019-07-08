{ stdenv, fetchurl, lib, vdr
, libav, libcap, libvdpau
, xineLib, libjpeg, libextractor, mesa, libGLU
, libX11, libXext, libXrender, libXrandr
, makeWrapper
}: let
  name = "vdr-xineliboutput-2.1.0";

  makeXinePluginPath = l: lib.concatStringsSep ":" (map (p: "${p}/lib/xine/plugins") l);

  self =  stdenv.mkDerivation {
    inherit name;

    src = fetchurl {
      url = "mirror://sourceforge/project/xineliboutput/xineliboutput/${name}/${name}.tgz";
      sha256 = "1phrxpaz8li7z0qy241spawalhcmwkv5hh3gdijbv4h7mm899yba";
    };

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
          --prefix XINE_PLUGIN_PATH ":" "${makeXinePluginPath [ "$out" xineLib ]}"
      done
    '';

    nativeBuildInputs = [ makeWrapper ];

    buildInputs = [
      libav
      libcap
      libextractor
      libjpeg
      libGLU
      libvdpau
      libXext
      libXrandr
      libXrender
      libX11
      mesa
      vdr
      xineLib
    ];

    passthru.requiredXinePlugins = [ xineLib self ];

    meta = with lib;{
      homepage = "https://sourceforge.net/projects/xineliboutput/";
      description = "Xine-lib based software output device for VDR";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };
  };
in self

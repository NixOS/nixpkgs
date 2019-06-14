{ stdenv, fetchurl, lib, vdr
, libav, libcap, libvdpau
, xineLib, libjpeg, libextractor, mesa_noglu, libGLU
, libX11, libXext, libXrender, libXrandr
, makeWrapper
}: let
  name = "vdr-xineliboutput-2.1.0";

  makeXinePluginPath = l: lib.concatStringsSep ":" (map (p: "${p}/lib/xine/plugins") l);

  self =  stdenv.mkDerivation {
    inherit name;

    src = fetchurl {
      name = "src.tgz";
      url = "https://sourceforge.net/projects/xineliboutput/files/xineliboutput/${name}/${name}.tgz/download";
      sha256 = "6af99450ad0792bd646c6f4058f6e49541aab8ba3a10e131f82752f4d5ed19de";
    };

    configurePhase = ''
      ./configure
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
      mesa_noglu
      vdr
      xineLib
    ];

    passthru.requiredXinePlugins = [ xineLib self ];

    meta = with lib;{
      homepage = https://sourceforge.net/projects/xineliboutput/;
      description = "xine-lib based software output device for VDR.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };
in self

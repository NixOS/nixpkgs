{ stdenv, fetchurl, lib, vdr
, libav, libcap, libvdpau
, xine-lib, libjpeg, libextractor, libglvnd, libGLU
, libX11, libXext, libXrender, libXrandr
, makeWrapper
}: let
  makeXinePluginPath = l: lib.concatStringsSep ":" (map (p: "${p}/lib/xine/plugins") l);

  self =  stdenv.mkDerivation rec {
    pname = "vdr-xineliboutput";
    version = "2.2.0";

    src = fetchurl {
      url = "mirror://sourceforge/project/xineliboutput/xineliboutput/${pname}-${version}/${pname}-${version}.tgz";
      sha256 = "0a24hs5nr7ncf51c5agyfn1xrvb4p70y3i0s6dlyyd9bwbfjldns";
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
      libav
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
in self

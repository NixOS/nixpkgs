{ stdenv, fetchurl, dpkg, makeWrapper, buildFHSUserEnv
, gnome3, gdk_pixbuf, cairo, libjpeg_original, glib, gnome2, libGLU
, nvidia_cg_toolkit, zlib, openssl, portaudio
}:
let
  fullPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    gnome3.gtk
    gdk_pixbuf
    cairo
    libjpeg_original
    glib
    gnome2.pango
    libGLU
    nvidia_cg_toolkit
    zlib
    openssl
    portaudio
  ];

  lightworks = stdenv.mkDerivation rec {
    version = "14.0.0";
    name = "lightworks-${version}";
    
    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "http://downloads.lwks.com/v14/lwks-14.0.0-amd64.deb";
          sha256 = "66eb9f9678d979db76199f1c99a71df0ddc017bb47dfda976b508849ab305033";
        }
      else throw "${name} is not supported on ${stdenv.hostPlatform.system}";

    buildInputs = [ dpkg makeWrapper ];

    phases = [ "unpackPhase" "installPhase" ];
    unpackPhase = "dpkg-deb -x ${src} ./";

    installPhase = ''
      mkdir -p $out/bin
      substitute usr/bin/lightworks $out/bin/lightworks \
        --replace "/usr/lib/lightworks" "$out/lib/lightworks"
      chmod +x $out/bin/lightworks

      cp -r usr/lib $out

      # /usr/share/fonts is not normally searched
      # This adds it to lightworks' search path while keeping the default
      # using the FONTCONFIG_FILE env variable
      echo "<?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
          <dir>/usr/share/fonts/truetype</dir>
          <include>/etc/fonts/fonts.conf</include>
      </fontconfig>" > $out/lib/lightworks/fonts.conf

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/lib/lightworks/ntcardvt

      wrapProgram $out/lib/lightworks/ntcardvt \
        --prefix LD_LIBRARY_PATH : ${fullPath}:$out/lib/lightworks \
        --set FONTCONFIG_FILE $out/lib/lightworks/fonts.conf
       
      cp -r usr/share $out/share
    '';

    dontPatchELF = true;

    meta = {
      description = "Professional Non-Linear Video Editor";
      homepage = "https://www.lwks.com/";
      license = stdenv.lib.licenses.unfree;
      maintainers = [ stdenv.lib.maintainers.antonxy ];
      platforms = [ "x86_64-linux" ];
    };
  };

# Lightworks expects some files in /usr/share/lightworks
in buildFHSUserEnv rec {
  name = lightworks.name;

  targetPkgs = pkgs: [
      lightworks
  ];

  runScript = "lightworks";
}

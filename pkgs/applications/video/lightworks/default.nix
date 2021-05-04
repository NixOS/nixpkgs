{ lib, stdenv, fetchurl, dpkg, makeWrapper, buildFHSUserEnv
, gtk3, gdk-pixbuf, cairo, libjpeg_original, glib, pango, libGLU
, libGL, nvidia_cg_toolkit, zlib, openssl, libuuid , alsaLib, udev
}:
let
  fullPath = lib.makeLibraryPath [
    stdenv.cc.cc
    gtk3
    gdk-pixbuf
    cairo
    libjpeg_original
    glib
    pango
    libGL
    libGLU
    nvidia_cg_toolkit
    zlib
    openssl
    libuuid
    alsaLib
    udev
  ];

  lightworks = stdenv.mkDerivation rec {
    version = "2021.2";
    pname = "lightworks";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://cdn.lwks.com/releases/2021.2/lightworks_2021.2_r128258.deb";
          sha256 = "sha256-IRzoysfGh/P+Xr50+cIjjaKuxdSzgCmJDICFtekfE3Y=";
        }
      else throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ dpkg ];

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
      <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
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
  };

# Lightworks expects some files in /usr/share/lightworks
in buildFHSUserEnv {
  name = lightworks.name;

  targetPkgs = pkgs: [
      lightworks
  ];

  runScript = "lightworks";

  meta = {
    description = "Professional Non-Linear Video Editor";
    homepage = "https://www.lwks.com/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.antonxy ];
    platforms = [ "x86_64-linux" ];
  };
}

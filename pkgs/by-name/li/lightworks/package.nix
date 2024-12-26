{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  buildFHSEnv,
  gtk3,
  gdk-pixbuf,
  cairo,
  libjpeg_original,
  glib,
  pango,
  libGLU,
  libGL,
  nvidia_cg_toolkit,
  zlib,
  openssl,
  libuuid,
  alsa-lib,
  udev,
  libjack2,
  freetype,
  libva,
  libvdpau,
  twolame,
  gmp,
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
    alsa-lib
    libjack2
    udev
    freetype
    libva
    libvdpau
    twolame
    gmp
  ];

  lightworks = stdenv.mkDerivation rec {
    version = "2023.2";
    rev = "146752";
    pname = "lightworks";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://cdn.lwks.com/releases/${version}/lightworks_${version}_r${rev}.deb";
          sha256 = "sha256-Xjcqdhe85YdPX8AHpKmo/K77AURg0JvtqIvilQOV2ek=";
        }
      else
        throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

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
        --prefix LD_LIBRARY_PATH : $out/lib/lightworks:${fullPath} \
        --set FONTCONFIG_FILE $out/lib/lightworks/fonts.conf

      cp -r usr/share $out/share
    '';

    dontPatchELF = true;
  };

in
# Lightworks expects some files in /usr/share/lightworks
buildFHSEnv {
  inherit (lightworks) pname version;

  targetPkgs = pkgs: [ lightworks ];

  runScript = "lightworks";

  meta = {
    description = "Professional Non-Linear Video Editor";
    homepage = "https://www.lwks.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "lightworks";
    maintainers = with lib.maintainers; [
      antonxy
      vojta001
      kashw2
    ];
    platforms = [ "x86_64-linux" ];
  };
}

{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  # instead of default patchelf, for bundled qemu binaries have non-contiguous PT_NOTE segments
  patchelfUnstable,
  which,
  zlib,
  libGL,
  glib,
  libx11,
  libxkbcommon,
  xdg-utils,
  libxrender,
  fontconfig,
  freetype,
  systemd,
  libpulseaudio,
  cairo,
  gdk-pixbuf,
  gtk3,
  pixman,
  # For glewinfo
  libxmu,
  libxi,
  libxext,
  nss,
  nspr,
  expat,
  libxcb,
  alsa-lib,
}:

let
  packages = [
    stdenv.cc.cc
    zlib
    glib
    libx11
    libxkbcommon
    libxmu
    libxi
    libxext
    libGL
    libxrender
    fontconfig
    freetype
    systemd
    libpulseaudio
    cairo
    gdk-pixbuf
    gtk3
    pixman
    nss
    nspr
    expat
    libxcb
    alsa-lib
  ];
  libPath = lib.makeLibraryPath packages;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "genymotion";
  version = "3.10.0";
  src = fetchurl {
    url = "https://dl.genymotion.com/releases/genymotion-${finalAttrs.version}/genymotion-${finalAttrs.version}-linux_x64.run";
    name = "genymotion-${finalAttrs.version}-linux_x64.run";
    hash = "sha256-y5kkAJpRt9EOYAmgos0+X6XFPgd2z2XEtCq76vAVt8c=";
  };

  nativeBuildInputs = [
    makeWrapper
    which
    xdg-utils
    patchelfUnstable
  ];

  unpackPhase = ''
    mkdir -p phony-home $out/share/applications
    export HOME=$TMP/phony-home

    mkdir genymotion
    sh $src --yes -d genymotion
    sourceRoot=genymotion

    for desktopFile in genymotion-launchpad genymotion-player; do
      substitute phony-home/.local/share/applications/$desktopFile.desktop \
        $out/share/applications/$desktopFile.desktop \
        --replace-fail "$TMP/genymotion" "$out/libexec"
    done
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    mv genymotion $out/libexec/
    ln -s $out/libexec/genymotion/{genymotion,player} $out/bin
  '';

  fixupPhase = ''
    patchInterpreter() {
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$out/libexec/genymotion/$1"
    }

    patchExecutable() {
      patchInterpreter "$1"
      wrapProgram "$out/libexec/genymotion/$1" \
        --set "LD_LIBRARY_PATH" "${libPath}" \
        --unset "QML2_IMPORT_PATH" \
        --unset "QT_PLUGIN_PATH"
    }

    patchTool() {
      patchInterpreter "tools/$1"
      wrapProgram "$out/libexec/genymotion/tools/$1" \
        --set "LD_LIBRARY_PATH" "${libPath}"
    }

    patchExecutable genymotion
    patchExecutable player
    patchInterpreter qemu/x86_64/bin/qemu-img
    patchInterpreter qemu/x86_64/bin/qemu-system-x86_64

    patchTool adb
    patchTool aapt
    patchTool glewinfo

    rm $out/libexec/genymotion/libxkbcommon*
  '';

  meta = {
    description = "Fast and easy Android emulation";
    longDescription = ''
      Genymotion is a relatively fast Android emulator which comes with
      pre-configured Android (x86 with OpenGL hardware acceleration) images,
      suitable for application testing.
    '';
    homepage = "https://www.genymotion.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      puffnfresh
      ulysseszhan
    ];
  };
})

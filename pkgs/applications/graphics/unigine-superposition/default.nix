{
  lib,
  glib,
  stdenv,
  dbus,
  freetype,
  fontconfig,
  zlib,
  qtquickcontrols2,
  libXinerama,
  libxcb,
  libSM,
  libXi,
  libglvnd,
  libXext,
  libXrandr,
  mailspring,
  libX11,
  libICE,
  libXrender,
  autoPatchelfHook,
  makeWrapper,
  mkDerivation,
  xkeyboard_config,
  fetchurl,
  buildFHSEnv,
  openal,
  makeDesktopItem,
}:

let
  pname = "unigine-superposition";
  version = "1.1";

  superposition = stdenv.mkDerivation rec {
    inherit pname version;

    src = fetchurl {
      url = "https://assets.unigine.com/d/Unigine_Superposition-${version}.run";
      sha256 = "12hzlz792pf8pvxf13fww3qhahqzwzkxq9q3mq20hbhvaphbg7nd";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      glib
      stdenv.cc.cc
      dbus
      freetype
      fontconfig
      zlib
      qtquickcontrols2
      libXinerama
      libxcb
      libSM
      libXi
      libglvnd
      libXext
      libXrandr
      mailspring
      libX11
      libICE
      libXrender
    ];

    installPhase = ''
      bash $src --target $name --noexec
      mkdir -p $out/bin $out/lib/unigine/superposition/
      cp -r $name/* $out/lib/unigine/superposition/
      echo "exec $out/lib/unigine/superposition/Superposition" >> $out/bin/superposition
      chmod +x $out/bin/superposition
       wrapProgram $out/lib/unigine/superposition/Superposition \
        --set QT_XKB_CONFIG_ROOT ${xkeyboard_config} \
        --run "cd $out/lib/unigine/superposition/"
    '';

    dontUnpack = true;
    dontWrapQtApps = true;

    postPatchMkspecs = ''
      cp -f $name/bin/superposition $out/lib/unigine/superposition/bin/superposition
    '';
  };

  desktopItem = makeDesktopItem {
    name = "Superposition";
    exec = "unigine-superposition";
    genericName = "A GPU Stress test tool from the UNIGINE";
    icon = "Superposition";
    desktopName = "Superposition Benchmark";
  };

in

# We can patch the "/bin/superposition", but "/bin/launcher" checks it for changes.
# For that we need use a buildFHSEnv.

buildFHSEnv {
  inherit pname version;

  targetPkgs = pkgs: [
    superposition
    glib
    stdenv.cc.cc
    dbus
    freetype
    fontconfig
    zlib
    qtquickcontrols2
    libXinerama
    libxcb
    libSM
    libXi
    libglvnd
    libXext
    libXrandr
    mailspring
    libX11
    libICE
    libXrender
    openal
  ];
  runScript = "superposition";

  extraInstallCommands = ''
    # create directories
    mkdir -p $out/share/icons/hicolor $out/share/applications
    # create .desktop file
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    # install Superposition.desktop and icon
    cp ${superposition}/lib/unigine/superposition/Superposition.png $out/share/icons/
    for RES in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
      cp ${superposition}/lib/unigine/superposition/icons/superposition_icon_$RES.png $out/share/icons/hicolor/"$RES"x"$RES"/apps/Superposition.png
    done
  '';

  meta = {
    description = "Unigine Superposition GPU benchmarking tool";
    homepage = "https://benchmark.unigine.com/superposition";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.BarinovMaxim ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "unigine-superposition";
  };
}

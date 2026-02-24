{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  buildFHSEnv,
  writeShellScript,
  gtk3,
  glib,
  glibc,
  libGL,
  mesa,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  dbus,
  libX11,
  libXext,
  libXrender,
  libXtst,
  libXi,
  libXfixes,
  libxcb,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXrandr,
  libXScrnSaver,
  alsa-lib,
  udev,
  nspr,
  nss,
  expat,
  cups,
  at-spi2-atk,
  at-spi2-core,
  libdrm,
  wayland,
  libxkbcommon,
  webkitgtk_4_1,
  openssl,
  zlib,
  libpng,
  libjpeg,
  freetype,
  fontconfig,
  sqlite,
  curl,
  vulkan-loader,
}:

let
  unwrapped = stdenv.mkDerivation rec {
    pname = "anycubic-slicer-next-unwrapped";
    version = "1.3.7171-20250928";

    src = fetchurl {
      url = "https://cdn-universe-slicer.anycubic.com/prod/dists/noble/main/binary-amd64/AnycubicSlicerNext-1.3.7171_20250928_162543-Ubuntu_24_04_2_LTS.deb";
      hash = "sha256-oB/oY8xO/o+UOXR4K/yy0dAIrjB3ztBl9j24k9ceH5I=";
    };

    nativeBuildInputs = [ autoPatchelfHook dpkg ];

    buildInputs = [
      gtk3 glib glibc libGL mesa cairo pango gdk-pixbuf atk dbus
      libX11 libXext libXrender libXtst libXi libXfixes libxcb
      libXcomposite libXcursor libXdamage libXrandr libXScrnSaver
      alsa-lib udev nspr nss expat cups at-spi2-atk at-spi2-core
      libdrm wayland libxkbcommon webkitgtk_4_1 openssl zlib libpng
      libjpeg freetype fontconfig sqlite curl
    ];

    autoPatchelfLibs = [ "lib/anycubic-slicer-next" ];

    unpackPhase = "dpkg-deb -x $src unpacked";

    installPhase = ''
      runHook preInstall

      install -Dm755 unpacked/usr/bin/AnycubicSlicerNext \
        $out/lib/anycubic-slicer-next/AnycubicSlicerNext

      find unpacked -name '*.so' -o -name '*.so.*' | while read f; do
        install -Dm755 "$f" $out/lib/anycubic-slicer-next/$(basename "$f")
      done

      mkdir -p $out/share
      cp -r unpacked/usr/share/AnycubicSlicerNext $out/share/AnycubicSlicerNext

      find unpacked -name "*.png" -o -name "*.svg" | while read f; do
        case "$(basename "$f")" in
          *icon*|*logo*|*Anycubic*|*anycubic*)
            mkdir -p $out/share/icons/hicolor/256x256/apps
            cp "$f" $out/share/icons/hicolor/256x256/apps/anycubic-slicer-next.png
            ;;
        esac
      done

      runHook postInstall
    '';
  };

  runtimeLibs = [
    gtk3 glib glibc libGL mesa cairo pango gdk-pixbuf atk dbus
    libX11 libXext libXrender libXtst libXi libXfixes libxcb
    libXcomposite libXcursor libXdamage libXrandr libXScrnSaver
    alsa-lib udev nspr nss expat cups at-spi2-atk at-spi2-core
    libdrm wayland libxkbcommon webkitgtk_4_1 openssl zlib libpng
    libjpeg freetype fontconfig sqlite curl vulkan-loader
  ];

  launcherScript = writeShellScript "anycubic-slicer-next-launcher" ''
    if [ -d /run/opengl-driver/lib ]; then
      export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
    fi

    export __GLX_VENDOR_LIBRARY_NAME=mesa
    export MESA_LOADER_DRIVER_OVERRIDE=zink
    export GALLIUM_DRIVER=zink
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    
    if [ -f /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json ]; then
      export __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
    fi

    exec /lib/anycubic-slicer-next/AnycubicSlicerNext "$@"
  '';

in buildFHSEnv {
  name = "AnycubicSlicerNext";

  targetPkgs = _: runtimeLibs ++ [ unwrapped ];

  extraBwrapArgs = [
    "--ro-bind" "${unwrapped}/share/AnycubicSlicerNext" "/usr/share/AnycubicSlicerNext"
  ];

  runScript = "${launcherScript}";

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps

    cp ${unwrapped}/share/icons/hicolor/256x256/apps/anycubic-slicer-next.png \
       $out/share/icons/hicolor/256x256/apps/

    cat > $out/share/applications/AnycubicSlicerNext.desktop << EOF
[Desktop Entry]
Name=Anycubic Slicer Next
Comment=G-code slicer for Anycubic 3D printers
Exec=$out/bin/AnycubicSlicerNext
Icon=anycubic-slicer-next
Terminal=false
Type=Application
Categories=Graphics;3DGraphics;Engineering;
StartupNotify=true
EOF
  '';

  meta = with lib; {
    description = "G-code slicer for Anycubic 3D printers, based on OrcaSlicer";
    homepage = "https://wiki.anycubic.com/en/software-and-app/anycubic-slicer-next-linux";
    license = licenses.agpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "AnycubicSlicerNext";
    maintainers = [ ];
  };
}

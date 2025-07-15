{
  autoPatchelfHook,
  cairo,
  dbus,
  requireFile,
  fontconfig,
  freetype,
  glib,
  gtk3,
  lib,
  libdrm,
  libGL,
  libkrb5,
  libsecret,
  libsForQt5,
  libunwind,
  libxkbcommon,
  makeWrapper,
  openssl,
  stdenv,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ida-free";
  version = "9.1";

  src = requireFile {
    name = "ida-free-pc_${lib.replaceStrings [ "." ] [ "" ] version}_x64linux.run";
    url = "https://my.hex-rays.com/dashboard/download-center/${version}/ida-free";
    hash = "sha256-DIkxr9yD6yvziO8XHi0jt80189bXueRxmSFyq2LM0cg=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
  ];

  # We just get a runfile in $src, so no need to unpack it.
  dontUnpack = true;

  # Add everything to the RPATH, in case IDA decides to dlopen things.
  runtimeDependencies = [
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    libsForQt5.qtbase
    libunwind
    libxkbcommon
    openssl
    stdenv.cc.cc
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];
  buildInputs = runtimeDependencies;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/opt
    mkdir -p $out/.local/share/applications

    # IDA depends on quite some things extracted by the runfile, so first extract everything
    # into $out/opt, then remove the unnecessary files and directories.
    IDADIR=$out/opt

    # The installer doesn't honor `--prefix` in all places,
    # thus needing to set `HOME` here.
    HOME=$out

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) $src \
      --mode unattended --prefix $IDADIR

    # Copy the exported libraries to the output.
    cp $IDADIR/libida.so $out/lib

    # Some libraries come with the installer.
    addAutoPatchelfSearchPath $IDADIR

    for bb in ida assistant; do
      wrapProgram $IDADIR/$bb \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms
      ln -s $IDADIR/$bb $out/bin/$bb
    done

    # runtimeDependencies don't get added to non-executables, and openssl is needed
    #  for cloud decompilation
    patchelf --add-needed libcrypto.so $IDADIR/libida.so

    mv $out/.local/share $out
    rm -r $out/.local

    runHook postInstall
  '';

  meta = with lib; {
    description = "Freeware version of the world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-free/";
    changelog = "https://hex-rays.com/products/ida/news/";
    license = licenses.unfree;
    mainProgram = "ida";
    maintainers = with maintainers; [ msanft ];
    platforms = [ "x86_64-linux" ]; # Right now, the installation script only supports Linux.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

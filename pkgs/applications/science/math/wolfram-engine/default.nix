{ lib
, stdenv
, autoPatchelfHook
, requireFile
, alsa-lib
, dbus
, fontconfig
, freetype
, gcc
, glib
, installShellFiles
, libssh2
, ncurses
, opencv4
, openssl
, unixODBC
, xkeyboard_config
, xorg
, zlib
, libxml2
, libuuid
, lang ? "en"
, libGL
, libGLU
, wrapQtAppsHook
}:

let
  l10n = import ./l10ns.nix {
    lib = lib;
    inherit requireFile lang;
  };
  dirName = "WolframEngine";
in
stdenv.mkDerivation rec {
  inherit (l10n) version name src;

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    wrapQtAppsHook
  ];
  dontWrapQtApps = true;

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    freetype
    gcc.cc
    gcc.libc
    glib
    libssh2
    ncurses
    opencv4
    openssl
    stdenv.cc.cc.lib
    unixODBC
    xkeyboard_config
    libxml2
    libuuid
    zlib
    libGL
    libGLU
  ] ++ (with xorg; [
    libX11
    libXext
    libXtst
    libXi
    libXmu
    libXrender
    libxcb
    libXcursor
    libXfixes
    libXrandr
    libICE
    libSM
  ]);

  # some bundled libs are found through LD_LIBRARY_PATH
  autoPatchelfIgnoreMissingDeps = true;

  ldpath = lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
      (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs);

  unpackPhase = ''
    # find offset from file
    offset=$(${stdenv.shell} -c "$(grep -axm1 -e 'offset=.*' $src); echo \$offset" $src)
    dd if="$src" ibs=$offset skip=1 | tar -xf -
    cd Unix
  '';

  installPhase = ''
    cd Installer
    sed -i -e 's/^PATH=/# PATH=/' -e 's/=`id -[ug]`/=0/' MathInstaller

    # Installer wants to write default config in HOME
    export HOME=$(mktemp -d)

    # Fix the installation script
    patchShebangs MathInstaller
    substituteInPlace MathInstaller \
      --replace '`hostname`' "" \
      --replace "chgrp" "# chgrp" \
      --replace "chown" ": # chown"

    # Install the desktop items
    export XDG_DATA_HOME="$out/share"

    ./MathInstaller -auto -createdir=y -execdir=$out/bin -targetdir=$out/libexec/${dirName} -silent

    # Fix library paths
    cd $out/libexec/${dirName}/Executables
    for path in MathKernel math mcc wolfram; do
      makeWrapper $out/libexec/${dirName}/Executables/$path $out/bin/$path --set LD_LIBRARY_PATH "${zlib}/lib:${stdenv.cc.cc.lib}/lib:${libssh2}/lib:\''${LD_LIBRARY_PATH}"
    done

    for path in WolframKernel wolframscript; do
      makeWrapper $out/libexec/${dirName}/SystemFiles/Kernel/Binaries/Linux-x86-64/$path $out/bin/$path --set LD_LIBRARY_PATH "${zlib}/lib:${stdenv.cc.cc.lib}/lib:${libssh2}/lib:\''${LD_LIBRARY_PATH}"
    done

    wrapQtApp "$out/libexec/${dirName}/SystemFiles/FrontEnd/Binaries/Linux-x86-64/WolframPlayer" \
      --set LD_LIBRARY_PATH "${zlib}/lib:${stdenv.cc.cc.lib}/lib:${libssh2}/lib:\''${LD_LIBRARY_PATH}" \
      --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb"
    if ! isELF "$out/libexec/${dirName}/SystemFiles/FrontEnd/Binaries/Linux-x86-64/WolframPlayer"; then
      substituteInPlace $out/libexec/${dirName}/SystemFiles/FrontEnd/Binaries/Linux-x86-64/WolframPlayer \
        --replace "TopDirectory=" "TopDirectory=$out/libexec/${dirName} #";
    fi

    for path in WolframPlayer wolframplayer; do
      makeWrapper $out/libexec/${dirName}/Executables/$path $out/bin/$path
    done

    # Install man pages
    installManPage $out/libexec/${dirName}/SystemFiles/SystemDocumentation/Unix/*
  '';

  # This is primarily an IO bound build; there's little benefit to building remotely.
  preferLocalBuild = true;

  # Stripping causes the program to core dump.
  dontStrip = true;

  meta = with lib; {
    description = "Wolfram Engine computational software system";
    homepage = "https://www.wolfram.com/engine/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ fbeffa ];
    platforms = [ "x86_64-linux" ];
  };
}

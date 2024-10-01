{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  zlib,
  glib,
  libpng,
  freetype,
  openssl,
  xorg,
  fontconfig,
  qtbase,
  qtwebengine,
  qtwebchannel,
  qtsvg,
  qtwebsockets,
  xkeyboard_config,
  alsa-lib,
  libpulseaudio ? null,
  libredirect,
  quazip,
  which,
  unzip,
  perl,
  llvmPackages,
}:

let

  arch = "amd64";

  libDir = "lib64";

  deps = [
    zlib
    glib
    libpng
    freetype
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    openssl
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcursor
    xorg.libXinerama
    xorg.libxcb
    fontconfig
    xorg.libXext
    xorg.libX11
    alsa-lib
    qtbase
    qtwebengine
    qtwebchannel
    qtsvg
    qtwebsockets
    libpulseaudio
    quazip
    llvmPackages.libcxx
  ];

  desktopItem = makeDesktopItem {
    name = "teamspeak";
    exec = "ts3client";
    icon = "teamspeak";
    comment = "The TeamSpeak voice communication tool";
    desktopName = "TeamSpeak";
    genericName = "TeamSpeak";
    categories = [ "Network" ];
  };
in

stdenv.mkDerivation rec {
  pname = "teamspeak-client";

  version = "3.6.2";

  src = fetchurl {
    url = "https://files.teamspeak-services.com/releases/client/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run";
    hash = "sha256-WfEQQ4lxoj+QSnAOfdCoEc+Z1Oa5dbo6pFli1DsAZCI=";
  };

  # grab the plugin sdk for the desktop icon
  pluginsdk = fetchurl {
    url = "http://dl.4players.de/ts/client/pluginsdk/pluginsdk_3.1.1.1.zip";
    sha256 = "1bywmdj54glzd0kffvr27r84n4dsd0pskkbmh59mllbxvj0qwy7f";
  };

  nativeBuildInputs = [
    makeWrapper
    which
    unzip
    perl # Installer script needs `shasum`
  ];

  # This just runs the installer script. If it gets stuck at something like
  # ++ exec
  # + PAGER_PATH=
  # it's looking for a dependency and didn't find it. Check the script and make sure the dep is in nativeBuildInputs.
  unpackPhase = ''
    echo -e '\ny' | PAGER=cat sh -xe $src
    cd TeamSpeak*
  '';

  buildPhase = ''
    mv ts3client_linux_${arch} ts3client
    echo "patching ts3client..."
    patchelf --replace-needed libquazip.so ${quazip}/lib/libquazip1-qt5.so ts3client
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath deps}:$(cat $NIX_CC/nix-support/orig-cc)/${libDir} \
      --force-rpath \
      ts3client
  '';

  installPhase =
    ''
      # Delete unecessary libraries - these are provided by nixos.
      rm *.so.* *.so
      rm QtWebEngineProcess
      rm qt.conf
      rm -r platforms # contains libqxcb.so

      # Install files.
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/

      # Make a desktop item
      mkdir -p $out/share/applications/ $out/share/icons/hicolor/64x64/apps/
      unzip ${pluginsdk}
      cp pluginsdk/docs/client_html/images/logo.png $out/share/icons/hicolor/64x64/apps/teamspeak.png
      cp ${desktopItem}/share/applications/* $out/share/applications/

      # Make a symlink to the binary from bin.
      mkdir -p $out/bin/
      ln -s $out/lib/teamspeak/ts3client $out/bin/ts3client

      wrapProgram $out/bin/ts3client \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set QT_PLUGIN_PATH "${qtbase}/${qtbase.qtPluginPrefix}" \
    '' # wayland is currently broken, remove when TS3 fixes that
    + ''
      --set QT_QPA_PLATFORM xcb \
      --set NIX_REDIRECTS /usr/share/X11/xkb=${xkeyboard_config}/share/X11/xkb
    '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "The TeamSpeak voice communication tool";
    homepage = "https://teamspeak.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = {
      # See distribution-permit.txt for a confirmation that nixpkgs is allowed to distribute TeamSpeak.
      fullName = "Teamspeak client license";
      url = "https://www.teamspeak.com/en/privacy-and-terms/";
      free = false;
    };
    maintainers = with maintainers; [
      lhvwb
      lukegb
      atemu
    ];
    mainProgram = "ts3client";
    platforms = [ "x86_64-linux" ];
  };
}

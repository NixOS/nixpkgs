{ lib, stdenv, fetchurl, makeWrapper, makeDesktopItem, zlib, glib, libpng, freetype, openssl
, xorg, fontconfig, qtbase, qtwebengine, qtwebchannel, qtsvg, qtwebsockets, xkeyboard_config
<<<<<<< HEAD
, alsa-lib, libpulseaudio ? null, libredirect, quazip, which, unzip, perl, llvmPackages
=======
, alsa-lib, libpulseaudio ? null, libredirect, quazip, which, unzip, llvmPackages_10, writeShellScriptBin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let

<<<<<<< HEAD
  arch = "amd64";

  libDir = "lib64";
=======
  arch = if stdenv.is64bit then "amd64" else "x86";

  libDir = if stdenv.is64bit then "lib64" else "lib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  deps =
    [ zlib glib libpng freetype xorg.libSM xorg.libICE xorg.libXrender openssl
      xorg.libXrandr xorg.libXfixes xorg.libXcursor xorg.libXinerama
      xorg.libxcb fontconfig xorg.libXext xorg.libX11 alsa-lib qtbase qtwebengine qtwebchannel qtsvg
<<<<<<< HEAD
      qtwebsockets libpulseaudio quazip llvmPackages.libcxx llvmPackages.libcxxabi
=======
      qtwebsockets libpulseaudio quazip llvmPackages_10.libcxx llvmPackages_10.libcxxabi # llvmPackages_11 and higher crash https://github.com/NixOS/nixpkgs/issues/161395
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======

  fakeLess = writeShellScriptBin "less" "cat";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in

stdenv.mkDerivation rec {
  pname = "teamspeak-client";

<<<<<<< HEAD
  version = "3.6.1";

  src = fetchurl {
    url = "https://files.teamspeak-services.com/releases/client/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run";
    hash = "sha256-j4sgZ+tJpV6ST0yLmbLTLgBxQTcK1LZoEEfMe3TUAC4=";
=======
  version = "3.5.6";

  src = fetchurl {
    url = "https://files.teamspeak-services.com/releases/client/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run";
    sha256 = if stdenv.is64bit
                then "sha256:0hjai1bd4mq3g2dlyi0zkn8s4zlgxd38skw77mb78nc4di5gvgpg"
                else "sha256:1y1c65nap91nv9xkvd96fagqbfl56p9n0rl6iac0i29bkysdmija";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # grab the plugin sdk for the desktop icon
  pluginsdk = fetchurl {
    url = "http://dl.4players.de/ts/client/pluginsdk/pluginsdk_3.1.1.1.zip";
    sha256 = "1bywmdj54glzd0kffvr27r84n4dsd0pskkbmh59mllbxvj0qwy7f";
  };

<<<<<<< HEAD
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
  unpackPhase =
    ''
      echo -e '\ny' | PAGER=cat sh -xe $src
=======
  nativeBuildInputs = [ makeWrapper fakeLess which unzip ];

  unpackPhase =
    ''
      echo -e '\ny' | sh -xe $src
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      cd TeamSpeak*
    '';

  buildPhase =
    ''
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
    '' /* wayland is currently broken, remove when TS3 fixes that */ + ''
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
      fullName = "Teamspeak client license";
      url = "https://www.teamspeak.com/en/privacy-and-terms/";
      free = false;
    };
<<<<<<< HEAD
    maintainers = with maintainers; [ lhvwb lukegb atemu ];
    mainProgram = "ts3client";
    platforms = [ "x86_64-linux" ];
=======
    maintainers = with maintainers; [ lhvwb lukegb ];
    platforms = [ "i686-linux" "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

/*
License issues:
Date: Mon, 10 Dec 2007 19:55:16 -0500
From: TeamSpeak Sales <sales@tritoncia.com>
To: 'Marc Weber' <marco-oweber@gmx.de>
Subject: RE: teamspeak on nix?

Yes, that would be fine.  As long as you are not renting servers or selling
TeamSpeak then you are more than welcome to distribute it.

Thank you,

TeamSpeak Sales Team
________________________________
e-Mail: sales@tritoncia.com
TeamSpeak: http://www.TeamSpeak.com
Account Login: https://sales.TritonCIA.com/users



-----Original Message-----
From: Marc Weber [mailto:marco-oweber@gmx.de]
Sent: Monday, December 10, 2007 5:03 PM
To: sales@tritoncia.com
Subject: teamspeak on nix?

Hello,

nix is very young software distribution system (http://nix.cs.uu.nl/)
I'd like to ask wether you permit us to add teamspeak (server/ client?)

Sincerly
Marc Weber (small nix contributor)
*/

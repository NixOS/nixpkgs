{ stdenv, fetchurl, makeWrapper, makeDesktopItem, zlib, glib, libpng, freetype, openssl
, xorg, fontconfig, qtbase, qtwebengine, qtwebchannel, xkeyboard_config, alsaLib, libpulseaudio ? null
, libredirect, quazip, less, which, unzip, llvmPackages
}:

let

  arch = if stdenv.is64bit then "amd64" else "x86";

  libDir = if stdenv.is64bit then "lib64" else "lib";

  deps =
    [ zlib glib libpng freetype xorg.libSM xorg.libICE xorg.libXrender openssl
      xorg.libXrandr xorg.libXfixes xorg.libXcursor xorg.libXinerama
      xorg.libxcb fontconfig xorg.libXext xorg.libX11 alsaLib qtbase qtwebengine qtwebchannel libpulseaudio
      quazip llvmPackages.libcxx llvmPackages.libcxxabi
    ];

  desktopItem = makeDesktopItem {
    name = "teamspeak";
    exec = "ts3client";
    icon = "teamspeak";
    comment = "The TeamSpeak voice communication tool";
    desktopName = "TeamSpeak";
    genericName = "TeamSpeak";
    categories = "Network";
  };

in

stdenv.mkDerivation rec {
  name = "teamspeak-client-${version}";

  version = "3.1.4";

  src = fetchurl {
    urls = [
      "http://dl.4players.de/ts/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
    ];
    sha256 = if stdenv.is64bit
                then "337aec99070366aa3bb82b1bedd8215372b9c74014b198d45d5d6375d1f1c3a8"
                else "4e126e005b1180655b0847cbdbfc9c47c59c639b7f93f0d988b54a8c4c6ec80f";
  };

  # grab the plugin sdk for the desktop icon
  pluginsdk = fetchurl {
    url = "http://dl.4players.de/ts/client/pluginsdk/pluginsdk_3.0.19.1.zip";
    sha256 = "1r1ss6zq5axr7h82inlp98zaz50041rizli5bwz3lfyipfr034ya";
  };

  buildInputs = [ makeWrapper less which unzip ];

  unpackPhase =
    ''
      echo -e 'q\ny' | sh -xe $src
      cd TeamSpeak*
    '';

  buildPhase =
    ''
      mv ts3client_linux_${arch} ts3client
      echo "patching ts3client..."
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath ${stdenv.lib.makeLibraryPath deps}:$(cat $NIX_CC/nix-support/orig-cc)/${libDir} \
        --force-rpath \
        ts3client
    '';

  installPhase =
    ''
      # Delete unecessary libraries - these are provided by nixos.
      rm *.so.* *.so
      rm QtWebEngineProcess
      rm qt.conf

      # Install files.
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/

      # Make a desktop item
      mkdir -p $out/share/applications/ $out/share/icons/
      unzip ${pluginsdk}
      cp pluginsdk/docs/client_html/images/logo.png $out/share/icons/teamspeak.png
      cp ${desktopItem}/share/applications/* $out/share/applications/

      # Make a symlink to the binary from bin.
      mkdir -p $out/bin/
      ln -s $out/lib/teamspeak/ts3client $out/bin/ts3client

      wrapProgram $out/bin/ts3client \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set QT_PLUGIN_PATH "$out/lib/teamspeak/platforms" \
        --set NIX_REDIRECTS /usr/share/X11/xkb=${xkeyboard_config}/share/X11/xkb
    '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "The TeamSpeak voice communication tool";
    homepage = http://teamspeak.com/;
    license = {
      fullName = "Teamspeak client license";
      url = http://sales.teamspeakusa.com/licensing.php;
      free = false;
    };
    maintainers = [ stdenv.lib.maintainers.lhvwb ];
    platforms = stdenv.lib.platforms.linux;
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

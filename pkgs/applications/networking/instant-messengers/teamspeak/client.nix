{ stdenv, fetchurl, zlib, glib, libpng, freetype, xorg, fontconfig, alsaLib,
  qt4, pulseaudio ? null }:

let

  version = "3.0.13.1";

  arch = if stdenv.is64bit then "amd64" else "x86";
 
  libDir = if stdenv.is64bit then "lib64" else "lib";

  deps =
    [ zlib glib libpng freetype xorg.libSM xorg.libICE xorg.libXrender
      xorg.libXrandr xorg.libXfixes xorg.libXcursor xorg.libXinerama
      fontconfig xorg.libXext xorg.libX11 alsaLib qt4 pulseaudio
    ];

in

stdenv.mkDerivation {
  name = "teamspeak-client-${version}";

  src = fetchurl {
    urls = [
       "http://dl.4players.de/ts/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
      "http://files.teamspeak-services.com/releases/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run"
    ];
    sha256 = if stdenv.is64bit 
		then "0mj8vpsnv906n3wgjwhiby5gk26jr5jbd94swmsf0s9kqwhsj6i1"
                else "1hlw7lc0nl1mrsyd052s6ws64q5aabnw6qpv8mrdxb3hyp7g2qh1";
  };

  unpackPhase =
    ''
      yes yes | sh $src
      cd TeamSpeak*
    '';

  buildPhase =
    ''
      mv ts3client_linux_${arch} ts3client
      echo "patching ts3client..."
      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath ${stdenv.lib.makeLibraryPath deps}:$(cat $NIX_GCC/nix-support/orig-gcc)/${libDir} \
        --force-rpath \
        ts3client
    '';

  installPhase =
    ''
      # Delete unecessary libraries - these are provided by nixos.
      rm *.so.*

      # Install files.
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/

      # Make a symlink to the binary from bin.
      mkdir -p $out/bin/
      ln -s $out/lib/teamspeak/ts3client $out/bin/ts3client
    '';

  dontStrip = true;
  dontPatchELF = true;
  
  meta = { 
    description = "The TeamSpeak voice communication tool";
    homepage = http://teamspeak.com/;
    license = "http://www.teamspeak.com/?page=downloads&type=ts3_linux_client_latest";
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

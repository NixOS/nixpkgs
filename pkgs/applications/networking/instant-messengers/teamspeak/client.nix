{ stdenv, fetchurl, zlib, glib, libpng, freetype, xorg, fontconfig, alsaLib }:

let

  libDir = if stdenv.is64bit then "lib64" else "lib";

  deps =
    [ zlib glib libpng freetype xorg.libSM xorg.libICE xorg.libXrender
      xorg.libXrandr xorg.libXfixes xorg.libXcursor xorg.libXinerama
      fontconfig xorg.libXext xorg.libX11 alsaLib
    ];

in

stdenv.mkDerivation {
  name = "teamspeak-client-3.0.0-beta35";

  src = fetchurl {
    url = http://ftp.4players.de/pub/hosted/ts3/releases/beta-35/TeamSpeak3-Client-linux_amd64-3.0.0-beta35.run;
    sha256 = "0vygsvjs11lr5lv4x7awv7hvkycvmm9qs2vklfjs91w3f434cmrx";
  };

  unpackPhase =
    ''
      yes yes | sh $src
      cd TeamSpeak*
    '';

  buildPhase =
    ''
      ls -l
      for i in ts3client_linux_*; do
        echo "patching $i..."
        patchelf \
          --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          --set-rpath ${stdenv.lib.makeLibraryPath deps}:$(cat $NIX_GCC/nix-support/orig-gcc)/${libDir} \
          --force-rpath \
          $i
      done
    '';
    

  installPhase =
    ''
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/
    '';

  dontStrip = true;
  dontPatchELF = true;
  
  meta = { 
    description = "The TeamSpeak voice communication tool";
    homepage = http://teamspeak.com/;
    license = "http://www.teamspeak.com/?page=downloads&type=ts3_linux_client_latest";
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

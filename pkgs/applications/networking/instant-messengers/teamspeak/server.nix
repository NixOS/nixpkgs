{ stdenv, fetchurl, makeWrapper }:

let

  version = "3.0.10.3";

  arch = if stdenv.is64bit then "amd64" else "x86";
 
  libDir = if stdenv.is64bit then "lib64" else "lib";
in

stdenv.mkDerivation {
  name = "teamspeak-server-${version}";

  src = fetchurl {
    urls = [
       "http://dl.4players.de/ts/releases/${version}/teamspeak3-server_linux-${arch}-${version}.tar.gz"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/teamspeak3-server_linux-${arch}-${version}.tar.gz"
    ];
    sha256 = if stdenv.is64bit 
      then "9606dd5c0c3677881b1aab833cb99f4f12ba08cc77ef4a97e9e282d9e10b0702"
      else "8b8921e0df04bf74068a51ae06d744f25d759a8c267864ceaf7633eb3f81dbe5";
  };

  buildInputs = [ makeWrapper ];

  buildPhase =
    ''
      mv ts3server_linux_${arch} ts3server
      echo "patching ts3server"
      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath $(cat $NIX_GCC/nix-support/orig-gcc)/${libDir} \
        --force-rpath \
        ts3server
    '';

  installPhase =
    ''
      # Delete unecessary libraries - these are provided by nixos.
      #rm *.so*

      # Install files.
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/

      # Make a symlink to the binary from bin.
      mkdir -p $out/bin/
      ln -s $out/lib/teamspeak/ts3server $out/bin/ts3server

      wrapProgram $out/lib/teamspeak/ts3server --prefix LD_LIBRARY_PATH : $out/lib/teamspeak
    '';

  dontStrip = true;
  dontPatchELF = true;
  
  meta = { 
    description = "TeamSpeak voice communication server";
    homepage = http://teamspeak.com/;
    license = stdenv.lib.licenses.unfreeRedistributable;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.arobyn ];
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

{ stdenv, fetchurl, makeWrapper }:

let
  version = "3.0.13.6";
  arch = if stdenv.is64bit then "amd64" else "x86";
  libDir = if stdenv.is64bit then "lib64" else "lib";
in

stdenv.mkDerivation {
  name = "teamspeak-server-${version}";

  src = fetchurl {
    urls = [
      "http://dl.4players.de/ts/releases/${version}/teamspeak3-server_linux_${arch}-${version}.tar.bz2"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/teamspeak3-server_linux_${arch}-${version}.tar.bz2"
    ];
    sha256 = if stdenv.is64bit 
      then "19ccd8db5427758d972a864b70d4a1263ebb9628fcc42c3de75ba87de105d179"
      else "2f70b3e70a3d9bf86106fab67a938922c8d27fec24e66e229913f78a0791b967";
  };

  buildInputs = [ makeWrapper ];

  buildPhase =
    ''
      echo "patching ts3server"
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $(cat $NIX_CC/nix-support/orig-cc)/${libDir} \
        --force-rpath \
        ts3server
      cp tsdns/tsdnsserver tsdnsserver
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $(cat $NIX_CC/nix-support/orig-cc)/${libDir} \
        --force-rpath \
        tsdnsserver
    '';

  installPhase =
    ''
      # Delete unecessary libraries - these are provided by nixos.
      #rm *.so*

      # Install files.
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/

      # Make symlinks to the binaries from bin.
      mkdir -p $out/bin/
      ln -s $out/lib/teamspeak/ts3server $out/bin/ts3server
      ln -s $out/lib/teamspeak/tsdnsserver $out/bin/tsdnsserver

      wrapProgram $out/lib/teamspeak/ts3server --prefix LD_LIBRARY_PATH : $out/lib/teamspeak
      wrapProgram $out/lib/teamspeak/tsdnsserver --prefix LD_LIBRARY_PATH : $out/lib/tsdnsserver
    '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "TeamSpeak voice communication server";
    homepage = https://teamspeak.com/;
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

{ stdenv, fetchurl, autoPatchelfHook }:

let
  arch = if stdenv.is64bit then "amd64" else "x86";
in stdenv.mkDerivation rec {
  pname = "teamspeak-server";
  version = "3.8.0";

  src = fetchurl {
    urls = [
      "http://dl.4players.de/ts/releases/${version}/teamspeak3-server_linux_${arch}-${version}.tar.bz2"
      "http://teamspeak.gameserver.gamed.de/ts3/releases/${version}/teamspeak3-server_linux_${arch}-${version}.tar.bz2"
    ];
    sha256 = if stdenv.is64bit
      then "1bzmqqqpwn6q2pvkrkkxq0ggs8crxbkwaxlggcdxjlyg95cyq8k1"
      else "0p5rqwdsvbria5dzjjm5mj8vfy0zpfs669wpbwxd4g3n4vh03kyw";
  };

  buildInputs = [ stdenv.cc.cc ];

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    # Install files.
    mkdir -p $out/lib/teamspeak
    mv * $out/lib/teamspeak/

    # Make symlinks to the binaries from bin.
    mkdir -p $out/bin/
    ln -s $out/lib/teamspeak/ts3server $out/bin/ts3server
    ln -s $out/lib/teamspeak/tsdnsserver $out/bin/tsdnsserver
  '';

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

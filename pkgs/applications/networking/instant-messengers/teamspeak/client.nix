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

args: with args;
stdenv.mkDerivation {
  name = "teamspeak-client-rc2-2032";

  src = fetchurl {
    url = ftp://213.202.254.114/teamspeak/releases/ts2_client_rc2_2032.tar.bz2;
    md5 = "e93d17a25e07b1cbe400e4eb028ca8f8";
  };

  phases="installPhase";

  rpathInputs = [ glibc x11 ];

  installPhase="
    set -x
    i=\$out/nix-support
    ensureDir \$out/{bin,nix-support}
    mv setup.data/image \$i
    cp \$out/{nix-support/image/TeamSpeak,bin}
    echo sed
    sed -i \"s=%installdir%=\$i/image=\" \$out/bin/TeamSpeak
      
    echo for
    for p in $\rpathInputs; do
      rpath=\$rpath:\$p/lib
    done
    echo patchelf
    patchelf --set-rpath \$rpath \$i/image/TeamSpeak.bin
  ";

  meta = { 
      description = "The TeamSpeak voice communication tool";
      homepage = http://www.goteamspeak.com;
      license = "TODO"; # non commercial use see email above 
  };
}

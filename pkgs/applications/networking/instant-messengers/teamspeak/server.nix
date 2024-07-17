{
  lib,
  stdenv,
  fetchurl,
  postgresql,
  autoPatchelfHook,
  writeScript,
}:

let
  arch = if stdenv.is64bit then "amd64" else "x86";
in
stdenv.mkDerivation rec {
  pname = "teamspeak-server";
  version = "3.13.7";

  src = fetchurl {
    url = "https://files.teamspeak-services.com/releases/server/${version}/teamspeak3-server_linux_${arch}-${version}.tar.bz2";
    sha256 =
      if stdenv.is64bit then
        "sha256-d1pXMamAmAHkyPkGbNm8ViobNoVTE5wSSfKgdA1QBB4="
      else
        "sha256-aMEDOnvBeKfzG8lDFhU8I5DYgG53IsCDBMV2MUyJi2g=";
  };

  buildInputs = [
    stdenv.cc.cc
    postgresql.lib
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    # Install files.
    mkdir -p $out/lib/teamspeak
    mv * $out/lib/teamspeak/

    # Make symlinks to the binaries from bin.
    mkdir -p $out/bin/
    ln -s $out/lib/teamspeak/ts3server $out/bin/ts3server
    ln -s $out/lib/teamspeak/tsdns/tsdnsserver $out/bin/tsdnsserver

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-teampeak-server" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl gnugrep gnused jq pup

    set -eu -o pipefail

    version=$( \
      curl https://www.teamspeak.com/en/downloads/ \
        | pup "#server .linux .version json{}" \
        | jq -r ".[0].text"
    )

    versionOld=$(nix-instantiate --eval --strict -A "teamspeak_server.version")

    nixFile=pkgs/applications/networking/instant-messengers/teamspeak/server.nix

    update-source-version teamspeak_server "$version" --system=i686-linux

    sed -i -e "s/version = \"$version\";/version = $versionOld;/" "$nixFile"

    update-source-version teamspeak_server "$version" --system=x86_64-linux
  '';

  meta = with lib; {
    description = "TeamSpeak voice communication server";
    homepage = "https://teamspeak.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      arobyn
      gerschtli
    ];
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

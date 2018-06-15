{ stdenv, fetchFromGitHub, alsaLib, libvorbis, tremor, flac, alsaUtils, avahi }:

stdenv.mkDerivation rec {
  name = "snapcast-client-${version}";
  version = "v0.11.1";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapcast";
    rev = version;
    sha256 = "15bzc4didslk6lprb74cv0d2m9hdvxh4vaah3jrkazvnignqmwfh";
    fetchSubmodules = true;
  };

  buildInputs = [ alsaLib alsaUtils libvorbis tremor flac avahi ];

  sourceRoot = "client";
  makeFlags = [ "DESTDIR=$(out)" ];

  installPhase = ''
    runHook preInstall
    install -vD snapclient $out/bin/snapclient
    install -vD snapclient.1 $out/share/man/man1/snapclient.1
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Synchronous multi-room audio player -- client";
    homepage = https://github.com/badaix/snapcast;
    license = licenses.gpl3;
    maintainers = with maintainers; [ TealG ];
    platforms = platforms.unix;
  };
}

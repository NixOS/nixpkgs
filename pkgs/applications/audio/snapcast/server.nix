{ stdenv, fetchFromGitHub, alsaLib, alsaUtils, libvorbis, flac, avahi }:

stdenv.mkDerivation rec {
  name = "snapcast-server-${version}";
  version = "v0.11.1";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapcast";
    rev = version;
    sha256 = "15bzc4didslk6lprb74cv0d2m9hdvxh4vaah3jrkazvnignqmwfh";
    fetchSubmodules = true;
  };

  buildInputs = [ alsaLib alsaUtils libvorbis flac avahi ];

  sourceRoot = "server";
  makeFlags = [ "DESTDIR=$(out)" ];

  installPhase = ''
    runHook preInstall
    install -vD snapserver $out/bin/snapserver
    install -vD snapserver.1 $out/share/man/man1/snapserver.1
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Synchronous multi-room audio player -- server";
    homepage = https://github.com/badaix/snapcast;
    license = licenses.gpl3;
    maintainers = with maintainers; [ TealG ];
    platforms = platforms.unix;
  };
}

{ stdenv, lib, fetchFromGitHub, xlibsWrapper, motif
, withAudioTracking ? false, libpulseaudio, aubio }:

stdenv.mkDerivation {
  pname = "catclock";
  version = "unstable-2021-11-15";

  src = fetchFromGitHub {
    owner = "BarkyTheDog";
    repo = "catclock";
    rev = "b2f277974b5a80667647303cabf8a89d6d6a4290";
    sha256 = "0ls02j9waqg155rj6whisqm7ppsdabgkrln92n4rmkgnwv25hdbi";
  };

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp xclock.man $out/share/man/man1/xclock.1
  '';

  makeFlags = [ "DESTINATION=$(out)/bin/" ]
    ++ lib.optional withAudioTracking "WITH_TEMPO_TRACKER=1";

  buildInputs = [ xlibsWrapper motif ]
    ++ lib.optionals withAudioTracking [ libpulseaudio aubio ];

  meta = with lib; {
    homepage = "http://codefromabove.com/2014/05/catclock/";
    description = "Analog / Digital / Cat clock for X";
    license = with licenses; mit;
    maintainers = with maintainers; [ ramkromberg ];
    mainProgram = "xclock";
    platforms = with platforms; linux ++ darwin;
  };
}

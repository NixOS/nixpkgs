{ lib, fetchFromGitHub, buildPythonApplication, pulseaudio
, PyChromecast, psutil, mutagen, flask, pyqt5, netifaces, requests, soco
, vorbis-tools, sox, lame, flac, faac, ffmpeg }:
buildPythonApplication rec {
  pname = "mkchromecast";
  version = "5872a246f0610b74fc2b197eb02dc91b96fb68cc";
  src = fetchFromGitHub {
    owner  = "muammar";
    repo   = "mkchromecast";
    rev    = version;
    sha256 = "05ldgx583s4b3qqn2r3sj7wjmfdqndkm59g2bwdkpz7pbcahkfmr";
  };

  propagatedBuildInputs = [
    PyChromecast psutil mutagen flask pyqt5 netifaces requests soco
    pulseaudio vorbis-tools sox lame flac faac ffmpeg
  ];

  doCheck = false;

  meta = with lib; {
    homepage = https://mkchromecast.com/;
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = licenses.mit;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}

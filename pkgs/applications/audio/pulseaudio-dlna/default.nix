{ fetchFromGitHub, stdenv, pythonPackages
, mp3Support ? true, lame ? null
, opusSupport ? true, opusTools ? null
, faacSupport ? false, faac ? null
, flacSupport ? true, flac ? null
, soxSupport ? true, sox ? null
, vorbisSupport ? true, vorbisTools ? null
}:

assert mp3Support -> lame != null;
assert opusSupport -> opusTools != null;
assert faacSupport -> faac != null;
assert flacSupport -> flac != null;
assert soxSupport -> sox != null;
assert vorbisSupport -> vorbisTools != null;

let
  zeroconf = pythonPackages.callPackage ./zeroconf.nix { };
in
pythonPackages.buildPythonApplication {
  pname = "pulseaudio-dlna";
  version = "unstable-2017-11-01";

  src = fetchFromGitHub {
    owner = "masmu";
    repo = "pulseaudio-dlna";
    rev = "4472928dd23f274193f14289f59daec411023ab0";
    sha256 = "1dfn7036vrq49kxv4an7rayypnm5dlawsf02pfsldw877hzdamqk";
  };

  propagatedBuildInputs = with pythonPackages; [
    dbus-python docopt requests setproctitle protobuf psutil futures
    chardet notify2 netifaces pyroute2 pygobject2 lxml setuptools ]
    ++ [ zeroconf ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional opusSupport opusTools
    ++ stdenv.lib.optional faacSupport faac
    ++ stdenv.lib.optional flacSupport flac
    ++ stdenv.lib.optional soxSupport sox
    ++ stdenv.lib.optional vorbisSupport vorbisTools;

  # upstream has no tests
  checkPhase = ''
    $out/bin/pulseaudio-dlna --help > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "A lightweight streaming server which brings DLNA / UPNP and Chromecast support to PulseAudio and Linux";
    homepage = "https://github.com/masmu/pulseaudio-dlna";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
  };
}

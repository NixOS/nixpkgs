{
  fetchFromGitHub,
  stdenv, gnumake, autoconf, automake, pkgconfig,
  libsndfile, gtk2, fftw,
  pulseSupport ? stdenv.config.pulseaudio or false, alsaSupport ? true, 
  libpulseaudio ? null, pulseaudio ? null, alsaLib ? null,
  cliSupport ? true, perl ? null,
  xdgSupport ? true, xdg_utils ? null
}:

assert pulseSupport || alsaSupport || (builtins.match ".*-darwin" stdenv.system != null);
assert pulseSupport -> libpulseaudio != null && pulseaudio != null;
assert alsaSupport  -> alsaLib != null;
assert cliSupport   -> perl != null;
assert xdgSupport   -> xdg_utils != null;

stdenv.mkDerivation rec {

  pname = "gtk-wave-cleaner";

  version = "0.22-01";

  src = fetchFromGitHub {
    owner = "AlisterH";
    repo = "gwc";
    rev = "eade82cf01270421973f955d82b91db479c58dbd";
    sha256 = "1argcaaank7ds16r4f9w193897pwg6y5yw5pd3jm2xkxhblkz6pd";
  };

  nativeBuildInputs = [
    gnumake 
    pkgconfig 
    autoconf 
    automake 
  ];

  preConfigure = "autoreconf -i";

  configureFlags = stdenv.lib.optional pulseSupport "--enable-pa"
                   ++ stdenv.lib.optional (! alsaSupport) "--disable-alsa";

  buildInputs = with stdenv.lib; [ 
    libsndfile 
    gtk2 
    fftw
  ] ++ optional pulseSupport pulseaudio
    ++ optional alsaSupport alsaLib
    ++ optional cliSupport perl
    ++ optional xdgSupport xdg_utils;

  meta = with stdenv.lib; {
    description = "A gui application to remove noise (hiss, pops and clicks) from audio files in WAV and similar formats";
    maintainers = [ maintainers.balsoft ];
    license = licenses.gpl2;
    platforms = platforms.all;
    homepage = "http://gwc.sourceforge.net/";
    downloadPage = "https://github.com/AlisterH/gwc/releases";
  };
}

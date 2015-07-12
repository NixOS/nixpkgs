{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, perl, python, which, makeWrapper
, libX11, libxcb, qt5, mesa
, ffmpeg
, libchardet
, mpg123
, libass
, libdvdread
, libdvdnav
, icu
, libquvi
, alsaLib
, libvdpau, libva
, libbluray
, jackSupport ? false, jack ? null
, portaudioSupport ? false, portaudio ? null
, pulseSupport ? true, libpulseaudio ? null
, cddaSupport ? false, libcdda ? null
, youtubeSupport ? true, youtube-dl ? null
}:

with stdenv.lib;

assert jackSupport -> jack != null;
assert portaudioSupport -> portaudio != null;
assert pulseSupport -> libpulseaudio != null;
assert cddaSupport -> libcdda != null;
assert youtubeSupport -> youtube-dl != null;

let
  waf = fetchurl {
    url = http://ftp.waf.io/pub/release/waf-1.8.4;
    sha256 = "1a7skwgpl91adhcwlmdr76xzdpidh91hvcmj34zz6548bpx3a87h";
  };

in

stdenv.mkDerivation rec {
  name = "bomi-${version}";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "xylosper";
    repo = "bomi";
    rev = "v${version}";
    sha256 = "0bi8kspwf5xvi3qqbk9hxjddz0x6j1d8w5xw7c0agbyd6dbw8sn7";
  };

  buildInputs = with stdenv.lib;
                [ libX11 libxcb mesa
                  qt5.base qt5.x11extras qt5.declarative qt5.quickcontrols
                  ffmpeg
                  libchardet
                  mpg123
                  libass
                  libdvdread
                  libdvdnav
                  icu
                  libquvi
                  alsaLib
                  libvdpau
                  libva
                  libbluray
                ]
                ++ optional jackSupport jack
                ++ optional portaudioSupport portaudio
                ++ optional pulseSupport libpulseaudio
                ++ optional cddaSupport libcdda
                ;

  preConfigure = ''
    patchShebangs configure
  '';

  preBuild = ''
    install -m755 ${waf} src/mpv/waf
    patchShebangs src/mpv/waf
    patchShebangs build-mpv
  '';

  postInstall = ''
    wrapProgram $out/bin/bomi \
      ${optionalString youtubeSupport "--prefix PATH ':' '${youtube-dl}/bin'"}
  '';

  configureFlags = with stdenv.lib;
                   [ "--qmake=qmake" ]
                   ++ optional jackSupport "--enable-jack"
                   ++ optional portaudioSupport "--enable-portaudio"
                   ++ optional pulseSupport "--enable-pulseaudio"
                   ++ optional cddaSupport "--enable-cdda"
                   ;

  nativeBuildInputs = [ pkgconfig perl python which qt5.tools makeWrapper ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful and easy-to-use multimedia player";
    homepage = https://bomi-player.github.io/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}

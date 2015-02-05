{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, perl, python3
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
, pulseSupport ? true, pulseaudio ? null
, cddaSupport ? false, libcdda ? null
}:

assert jackSupport -> jack != null;
assert portaudioSupport -> portaudio != null;
assert pulseSupport -> pulseaudio != null;
assert cddaSupport -> libcdda != null;

let
  waf = fetchurl {
    url = http://ftp.waf.io/pub/release/waf-1.8.4;
    sha256 = "1a7skwgpl91adhcwlmdr76xzdpidh91hvcmj34zz6548bpx3a87h";
  };

in

stdenv.mkDerivation rec {
  name = "bomi-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "xylosper";
    repo = "bomi";
    rev = "v${version}";
    sha256 = "12xyz40kl03h1m8g7d7s0wf74l2c70v6bd1drhww7ky48hxi0z14";
  };

  buildInputs = with stdenv.lib;
                [ libX11 libxcb qt5 mesa
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
                ++ optional pulseSupport pulseaudio
                ++ optional cddaSupport libcdda
                ;

  preConfigure = ''
    patchShebangs configure
    # src/mpv/waf build-mpv; do
  '';

  preBuild = ''
    patchShebangs build-mpv
    install -m755 ${waf} src/mpv/waf
    sed -i '1 s,.*,#!${python3.interpreter},' src/mpv/waf
  '';

  configureFlags = with stdenv.lib;
                   [ "--qmake=qmake" ]
                   ++ optional jackSupport "--enable-jack"
                   ++ optional portaudioSupport "--enable-portaudio"
                   ++ optional pulseSupport "--enable-pulseaudio"
                   ++ optional cddaSupport "--enable-cdda"
                   ;

  nativeBuildInputs = [ pkgconfig perl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful and easy-to-use multimedia player";
    homepage = https://bomi-player.github.io/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}

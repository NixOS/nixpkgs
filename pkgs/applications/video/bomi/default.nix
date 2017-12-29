{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, perl, python, which
, libX11, libxcb, mesa
, qtbase, qtdeclarative, qtquickcontrols, qttools, qtx11extras, qmake, makeWrapper
, libchardet
, ffmpeg

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

stdenv.mkDerivation rec {
  name = "bomi-${version}";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "xylosper";
    repo = "bomi";
    rev = "v${version}";
    sha256 = "0a7n46gn3n5098lxxvl3s29s8jlkzss6by9074jx94ncn9cayf2h";
  };

  patches = [
    (fetchpatch rec {
      name = "bomi-compilation-fix.patch";
      url = "https://svnweb.mageia.org/packages/cauldron/bomi/current/SOURCES/${name}?revision=995725&view=co&pathrev=995725";
      sha256 = "1dwryya5ljx35dbx6ag9d3rjjazni2mfn3vwirjdijdy6yz22jm6";
    })
    (fetchpatch rec {
      name = "bomi-fix-expected-unqualified-id-before-numeric-constant-unix.patch";
      url = "https://svnweb.mageia.org/packages/cauldron/bomi/current/SOURCES/${name}?revision=995725&view=co&pathrev=995725";
      sha256 = "0n3xsrdrggimzw30gxlnrr088ndbdjqlqr46dzmfv8zan79lv5ri";
    })
  ];

  buildInputs = with stdenv.lib;
                [ libX11
                  libxcb
                  mesa
                  qtbase
                  qtx11extras
                  qtdeclarative
                  qtquickcontrols
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
    patchShebangs src/mpv/waf
    patchShebangs build-mpv
  '';

  postInstall = ''
    wrapProgram $out/bin/bomi \
      ${optionalString youtubeSupport "--prefix PATH ':' '${youtube-dl}/bin'"}
  '';

  dontUseQmakeConfigure = true;

  configureFlags = with stdenv.lib;
                   [ "--qmake=qmake" ]
                   ++ optional jackSupport "--enable-jack"
                   ++ optional portaudioSupport "--enable-portaudio"
                   ++ optional pulseSupport "--enable-pulseaudio"
                   ++ optional cddaSupport "--enable-cdda"
                   ;

  nativeBuildInputs = [ makeWrapper pkgconfig perl python which qttools qmake ];

  meta = with stdenv.lib; {
    description = "Powerful and easy-to-use multimedia player";
    homepage = https://bomi-player.github.io/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}

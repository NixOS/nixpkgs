{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,

  boca, # Required for freac
  smooth, # Required for boca
  systemd,

  curl,
  gnome-icon-theme,
  openssl,

  # Codecs
#  exhale # Missing from nixpkgs as of 2024/12/18 ?
  faac, # free = false
  faad2,
  fdk_aac,
  ffmpeg,
  flac,
  lame,
  libcdio,
  libcdio-paranoia,
#  libcdrip, # Missing from nixpkgs as of 2024/12/18 ? (Windows?)
  libogg,
  libopus,
  libsamplerate,
  libsndfile,
  libvorbis,
#  mac,
  monkeysAudio,
  mp4v2,
  mpg123,
#  musepack, # Missing from nixpkgs as of 2024/12/18 ?
  rnnoise,
  rubberband,
  speex,
  wavpack,
}:
let
  buildDeps = with pkgs; [
    boca # Required for freac
    smooth # Required for boca
    systemd

    curl
    gnome-icon-theme
    openssl
  ];

  codecs = with pkgs; [
#    exhale            # 1.2.0 - https://gitlab.com/ecodis/exhale
    faac              # 1.30 - https://github.com/knik0/faac
    faad2             # 2.10.0 - https://github.com/knik0/faad2
    fdk_aac           # 2.0.3 - https://sourceforge.net/projects/opencore-amr/files/fdk-aac
    ffmpeg            # 7.1 - https://ffmpeg.org/releases
    flac              # 1.4.3 - https://ftp.osuosl.org/pub/xiph/releases/flac
    lame              # 3.100 - https://sourceforge.net/projects/lame/files/lame
    libcdio           # 2.1.0 - https://ftp.gnu.org/gnu/libcdio/
    libcdio-paranoia  # 10.2+2.0.1 - https://ftp.gnu.org/gnu/libcdio
#    libcdrip          # 2.4a - http://cdrip.org/releases/
    libogg            # 1.3.5 - https://ftp.osuosl.org/pub/xiph/releases/ogg
    libopus           # 1.5.2 - https://ftp.osuosl.org/pub/xiph/releases/opus
    libsamplerate     # 0.2.2 - https://github.com/libsndfile/libsamplerate
    libsndfile        # 1.2.2 - https://github.com/libsndfile/libsndfile
    libvorbis         # 1.3.7 - https://ftp.osuosl.org/pub/xiph/releases/vorbis
#    mac               # 10.82 - https://freac.org/patches
    monkeysAudio      # 10.82 - https://freac.org/patches
    mp4v2             # 2.1.3 - https://github.com/enzo1982/mp4v2
    mpg123            # 32.9 - https://mpg123.org/download
#    musepack          # 4.75 - https://files.musepack.net/source
    rnnoise           # 9acc1e5 - https://codeload.github.com/xiph/rnnoise
    rubberband        # 1.8.2 - https://breakfastquay.com/files/releases
    speex             # 1.2.1 - https://ftp.osuosl.org/pub/xiph/releases/speex
    wavpack           # 5.7.0 -https://www.wavpack.com/
    ];
in

# NOTE: For more details on building fre:ac for Linux & MacOS visit the following URLs:
#   https://github.com/enzo1982/freac/blob/master/.github/workflows/tools/build-appimage
#   https://github.com/enzo1982/freac/blob/master/.github/workflows/tools/build-macos
#   https://github.com/enzo1982/freac/blob/master/tools/build-codecs

# TODO: Add freac_latest to to make continuous build version available
# TODO: Instead of copying external libs into the package derivation, can we instead link them to the package somehow?

stdenv.mkDerivation (finalAttrs: {
  pname = "freac";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "freac";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bHoRxxhSM7ipRkiBG7hEa1Iw8Z3tOHQ/atngC/3X1a4=";
  };

  nativeBuildInputs = buildDeps;

  buildInputs = codecs;

  makeFlags = [
    "prefix=$(out)"
#    "config=release"
  ];

  # Note: Non-standard references to files by fre:ac requires following the structure as described in;
  #       https://github.com/enzo1982/freac/blob/master/.github/workflows/tools/build-appimage
  postBuild = ''
    codecs=$out/bin/codecs
    cmdline=$codecs/cmdline

    mkdir -p $out/boca
    mkdir -p $out/lang
    mkdir -p $cmdline
    mkdir -p $out/icons/gnome/32x32/status
    mkdir -p $out/usr/share/applications
    mkdir -p $out/usr/share/metainfo

    ##########
    # Install codecs
    install -Dm 444 ${lib.getLib flac}/lib/libFLAC.so                 $codecs/FLAC.so
#    install -Dm 444 $\{mac}/lib/libMAC.so                              $codecs/MAC.so
#    install -Dm 444 $\{mac}/lib/libmac.so                              $codecs/MAC.so
    install -Dm 444 ${faad2}/lib/libfaad.so                           $codecs/faad.so
    install -Dm 444 ${fdk_aac}/lib/libfdk-aac.so                      $codecs/fdk-aac.so
    install -Dm 444 ${lib.getLib lame}/lib/libmp3lame.so              $codecs/mp3lame.so
    install -Dm 444 ${mp4v2}/lib/libmp4v2.so                          $codecs/mp4v2.so
    install -Dm 444 ${mpg123}/lib/libmpg123.so                        $codecs/mpg123.so
    install -Dm 444 ${libogg}/lib/libogg.so                           $codecs/ogg.so
    install -Dm 444 ${libopus}/lib/libopus.so                         $codecs/opus.so
    install -Dm 444 ${rnnoise}/lib/librnnoise.so                      $codecs/rnnoise.so
    install -Dm 444 ${rubberband}/lib/librubberband.so                $codecs/rubberband.so
    install -Dm 444 ${lib.getLib libsamplerate}/lib/libsamplerate.so  $codecs/samplerate.so
    install -Dm 444 ${lib.getLib libsndfile}/lib/libsndfile.so        $codecs/sndfile.so
    install -Dm 444 ${speex}/lib/libspeex.so                          $codecs/speex.so
    install -Dm 444 ${libvorbis}/lib/libvorbis.so                     $codecs/vorbis.so
    install -Dm 444 ${libvorbis}/lib/libvorbisenc.so                  $codecs/vorbisenc.so

    install -Dm 0755 ${ffmpeg}/bin/ffmpeg                             $cmdline/ffmpeg
    # install -Dm 0755 $\{PACKAGE_NAME}/bin/mpcdec                   $cmdline/mpcdec # Musepack decode
    # install -Dm 0755 $\{PACKAGE_NAME}/bin/mpcenc                   $cmdline/mpcenc # Musepack encode
    install -Dm 0755 ${wavpack}/bin/wavpack                           $cmdline/wavpack
    install -Dm 0755 ${wavpack}/bin/wvunpack                          $cmdline/wvunpack

    ##########
    # Copy icons
    install -Dm 444 ${gnome-icon-theme}/share/icons/gnome/32x32/status/dialog-error.png        $out/icons/gnome/32x32/status/
    install -Dm 444 ${gnome-icon-theme}/share/icons/gnome/32x32/status/dialog-information.png  $out/icons/gnome/32x32/status/
    install -Dm 444 ${gnome-icon-theme}/share/icons/gnome/32x32/status/dialog-question.png     $out/icons/gnome/32x32/status/
    install -Dm 444 ${gnome-icon-theme}/share/icons/gnome/32x32/status/dialog-warning.png      $out/icons/gnome/32x32/status/

    ##########
    # Copy smooth
    cp ${lib.getLib smooth}/lib/libsmooth*.so.? $out

    ##########
    # Copy BoCA
    cp -r ${lib.getLib boca}/lib/boca $out
    ln -s $out/boca/boca.1.0.so       $out/libboca-1.0.so.3

    ##########
    # Copy fre:ac
    install -Dm 444 COPYING Readme* $out
    rm $out/Readme.md

    # FIXME: Locate paths and files for the two lines below - doesn't appear to be critical.
    echo "##########"
    find / -type d -name freac -ls || true
    echo "##########"
#    cp -r lib/freac/*   $out/boca/
    cp -r i18n/freac/*  $out/lang
    cp -r icons         $out
    cp -r manual        $out


    install -Dm 0755 ${smooth}/bin/smooth-translator $out/translator

    install -Dm 444 metadata/org.freac.freac.desktop           $out/usr/share/applications/
    install -Dm 444 metadata/org.freac.freac.appdata.xml       $out/usr/share/metainfo/
    ln -s $out/usr/share/applications/org.freac.freac.desktop  $out/org.freac.freac.desktop
    install -Dm 444 icons/freac.png                            $out/org.freac.freac.png

    ##########
    # Copy other dependencies
    install -Dm 444 ${libcdio}/lib/libcdio.so.19                  $out
    install -Dm 444 ${libcdio-paranoia}/lib/libcdio_cdda.so.2     $out
    install -Dm 444 ${libcdio-paranoia}/lib/libcdio_paranoia.so.2 $out
    install -Dm 444 ${lib.getLib curl}/lib/libcurl.so.4           $out

    install -Dm 444 ${lib.getLib openssl}/lib/libcrypto.so* $out
    install -Dm 444 ${lib.getLib openssl}/lib/libssl.so*    $out
  '';

  meta = with lib; {
    changelog = "https://github.com/enzo1982/freac/releases/tag/v${finalAttrs.version}";
    description = "Audio converter and CD ripper with support for various popular formats and encoders";
    homepage = "https://www.freac.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
})

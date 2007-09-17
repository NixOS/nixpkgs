# this nix expression is not well tested (experimental!)
args: with args.lib; with args;
let
  win32codecs = (import ./win32codecs) {
    inherit stdenv fetchurl;
  };
  co = chooseOptionsByFlags {
    inherit args;
    flagConfig = {
      # FIXME: we only have to pass X11 if we want to use a X11 driver 
      mandatory = { buildInputs = [ "x11" "libX11" "freetype" "zlib" ]; };

      # FIXME this options are still a mess.. :) feel free to test and implement the missing ones

      # Optional features
      #--disable-mencoder     disable mencoder (a/v encoder) compilation [enable]
      #--enable-gui           enable gmplayer compilation (GTK+ GUI) [disable]
      #--enable-gtk1          force using GTK 1.2 for GUI  [disable]
      #--enable-largefiles    enable support for files > 2 GBytes [disable]
      #--enable-linux-devfs   set default devices to devfs ones [disable]
      #--enable-termcap       use termcap database for key codes [autodetect]
      #--enable-termios       use termios database for key codes [autodetect]
      #--disable-iconv        do not use iconv(3) function [autodetect]
      #--disable-langinfo     do not use langinfo [autodetect]
      #--enable-lirc          enable LIRC (remote control) support [autodetect]
      #--enable-lircc         enable LIRCCD (LIRC client daemon) input [autodetect]
      #--enable-joystick      enable joystick support [disable]
      #--disable-vm           disable support X video mode extensions [autodetect]
      #--disable-xf86keysym   disable support for 'multimedia' keys [autodetect]
      #--enable-radio         enable Radio Interface [disable]
      #--enable-radio-capture enable Capture for Radio Interface (through pci/line-in) [disable]
      #--disable-radio-v4l2   disable Video4Linux2 Radio Interface support [autodetect]
      #--disable-tv           disable TV Interface (tv/dvb grabbers) [enable]
      #--disable-tv-v4l1      disable Video4Linux TV Interface support [autodetect]
      #--disable-tv-v4l2      disable Video4Linux2 TV Interface support [autodetect]
      #--disable-tv-bsdbt848  disable BSD BT848 Interface support [autodetect]
      #--disable-pvr          disable Video4Linux2 MPEG PVR support [autodetect]
      #--disable-rtc          disable RTC (/dev/rtc) on Linux [autodetect]
      #--disable-network      disable network support (for: http/mms/rtp) [enable]
      #--enable-winsock2      enable winsock2 usage [autodetect]
      #--enable-smb           enable Samba (SMB) input support [autodetect]
      #--enable-live          enable LIVE555 Streaming Media support [autodetect]
      #--disable-dvdnav       disable libdvdnav support [autodetect]
      #--disable-dvdread      Disable libdvdread support [autodetect]
      #--disable-mpdvdkit     Disable mpdvdkit2 support [autodetect]
      #--disable-cdparanoia   Disable cdparanoia support [autodetect]
      #--disable-bitmap-font  Disable bitmap font support [enable]
      #--disable-freetype     Disable freetype2 font rendering support [autodetect]
      #--disable-fontconfig   Disable fontconfig font lookup support [autodetect]
      #--disable-unrarlib     Disable Unique RAR File Library [enabled]
      #--enable-menu          Enable OSD menu support (NOT DVD MENU) [disabled]
      #--disable-sortsub      Disable subtitles sorting [enabled]
      #--enable-fribidi       Enable using the FriBiDi libs [autodetect]
      #--disable-enca         Disable using ENCA charset oracle library [autodetect]
      #--disable-macosx       Disable Mac OS X specific features [autodetect]
      #--disable-maemo        Disable maemo specific features [autodetect]
      #--enable-macosx-finder-support  Enable Mac OS X Finder invocation parameter parsing [disabled]
      #--enable-macosx-bundle Enable Mac OS X bundle file locations [autodetect]
      #--disable-inet6        Disable IPv6 support [autodetect]
      #--disable-gethostbyname2  gethostbyname() function is not provided by the C
                                #library [autodetect]
      #--disable-ftp          Disable ftp support [enabled]
      #--disable-vstream      Disable tivo vstream client support [autodetect]
      #--disable-pthreads     Disable Posix threads support [autodetect]
      #--disable-ass          Disable internal SSA/ASS subtitles support [autodetect]
      #--enable-rpath         Enable runtime linker path for extra libs [disabled]

      # Codecs
      #--enable-png           enable png input/output support [autodetect]
      #--enable-jpeg          enable jpeg input/output support [autodetect]
      #--enable-libcdio       enable external libcdio support [autodetect]
      #--enable-liblzo        enable external liblzo support [autodetect]
      #--disable-win32        disable Win32 DLL support [autodetect]
      #--disable-qtx          disable Quicktime codecs [autodetect]
      #--disable-xanim        disable XAnim DLL support [autodetect]
      #--disable-real         disable RealPlayer DLL support [autodetect]
      #--disable-xvid         disable XviD codec [autodetect]
      #--disable-x264         disable H.264 encoder [autodetect]
      #--disable-nut          disable libnut demuxer [autodetect]
      #--disable-libavutil    disable libavutil [autodetect]
      #--disable-libavcodec   disable libavcodec [autodetect]
      #--disable-libavformat  disable libavformat [autodetect]
      #--disable-libpostproc  disable libpostproc [autodetect]
      #--disable-libavutil_so   disable shared libavutil [autodetect]
      #--disable-libavcodec_so  disable shared libavcodec [autodetect]
      #--disable-libavformat_so disable shared libavformat [autodetect]
      #--disable-libpostproc_so disable shared libpostproc [autodetect]
      #--disable-libavcodec_mpegaudio_hp disable high precision audio decoding
      #                                  in libavcodec [enabled]
      #--enable-libfame       enable libfame realtime encoder [autodetect]
      #--disable-tremor-internal do not build internal Tremor support [enabled]
      #--enable-tremor-low    build with lower accuracy internal Tremor [disabled]
      #--enable-tremor-external build with external Tremor [autodetect]
      #--disable-libvorbis    disable libvorbis support [autodetect]
      #--disable-speex        disable Speex support [autodetect]
      theora = { cfgOption = "--enable-theora"; buildInputs = "libtheora"; };
      #--enable-theora        build with OggTheora support [autodetect]
      #--enable-faad-external build with external FAAD2 (AAC) support [autodetect]
      #--disable-faad-internal disable internal FAAD2 (AAC) support [autodetect]
      #--enable-faad-fixed    enable fixed-point mode in internal FAAD2 [disabled]
      #--disable-faac         disable support for FAAC (AAC encoder) [autodetect]
      #--disable-ladspa       disable LADSPA plugin support [autodetect]
      #--disable-libdv        disable libdv 0.9.5 en/decoding support [autodetect]
      #--disable-mad          disable libmad (MPEG audio) support [autodetect]
      #--disable-toolame      disable Toolame (MPEG layer 2 audio) support in mencoder [autodetect]
      #--disable-twolame      disable Twolame (MPEG layer 2 audio) support in mencoder [autodetect]
      #--enable-xmms          build with XMMS inputplugin support [disabled]
      #--disable-mp3lib       disable builtin mp3lib [enabled]
      #--disable-liba52       disable builtin liba52 [enabled]
      #--enable-libdts        enable libdts support [autodetect]
      #--disable-libmpeg2     disable builtin libmpeg2 [enabled]
      #--disable-musepack     disable musepack support [autodetect]
      #--disable-amr_nb       disable amr narrowband, floating point [autodetect]
      #--disable-amr_nb-fixed disable amr narrowband, fixed point [autodetect]
      #--disable-amr_wb       disable amr wideband, floating point [autodetect]
      #--disable-decoder=DECODER disable specified FFmpeg decoder
      #--enable-decoder=DECODER  enable specified FFmpeg decoder
      #--disable-encoder=ENCODER disable specified FFmpeg encoder
      #--enable-encoder=ENCODER  enable specified FFmpeg encoder
      #--disable-parser=PARSER   disable specified FFmpeg parser
      #--enable-parser=PARSER    enable specified FFmpeg parser
      #--disable-demuxer=DEMUXER disable specified FFmpeg demuxer
      #--enable-demuxer=DEMUXER  enable specified FFmpeg demuxer
      #--disable-muxer=MUXER     disable specified FFmpeg muxer
      #--enable-muxer=MUXER      enable specified FFmpeg muxer--enable-muxer=MUXER      enable specified FFmpeg muxer

     # Video output
      #--disable-vidix-internal disable internal VIDIX [for x86 *nix]
      #--disable-vidix-external disable external VIDIX [for x86 *nix]
      #--enable-gl            build with OpenGL render support [autodetect]
      #--enable-dga[=n]       build with DGA [n in {1, 2} ] support [autodetect]
      #--enable-vesa          build with VESA support [autodetect]
      #--enable-svga          build with SVGAlib support [autodetect]
      #--enable-sdl           build with SDL render support [autodetect]
      #--enable-aa            build with AAlib render support [autodetect]
      caca =              { cfgOption = "--enable-caca"; buildInputs = "libcaca"; };    # CACA render support
      #--enable-ggi           build with GGI render support [autodetect]
      #--enable-ggiwmh        build with GGI libggiwmh extension [autodetect]
      #--enable-directx       build with DirectX support [autodetect]
      #--enable-dxr2          build with DXR2 render support [autodetect]
      #--enable-dxr3          build with DXR3/H+ render support [autodetect]
      #--enable-ivtv          build with IVTV TV-Out render support [autodetect]
      #--enable-dvb           build with support for output via DVB-Card [autodetect]
      #--enable-dvbhead       build with DVB support (HEAD version) [autodetect]
      #--enable-mga           build with mga_vid (for Matrox G200/G4x0/G550) support
      #                       (check for /dev/mga_vid) [autodetect]
      #--enable-xmga          build with mga_vid X Window support
      #                       (check for X & /dev/mga_vid) [autodetect]
      xv       = { cfgOption = "--enable-xv"; buildInputs = "libXv"; }; # Xv render support for X 4.x
      #--enable-xvmc          build with XvMC acceleration for X 4.x [disable]
      #--enable-vm            build with XF86VidMode support for X11 [autodetect]
      xinerama = { cfgOption = "--enable-xinerama"; buildInputs = "libXinerama"; }; # Xinerama support for X11
      #--enable-x11           build with X11 render support [autodetect]
      #--enable-xshape        build with XShape support [autodetect]
      #--enable-fbdev         build with FBDev render support [autodetect]
      #--enable-mlib          build with mediaLib support (Solaris only) [disable]
      #--enable-3dfx          build with obsolete /dev/3dfx support [disable]
      #--enable-tdfxfb        build with tdfxfb (Voodoo 3/banshee) support [disable]
      #--enable-s3fb          build with s3fb (S3 ViRGE) support [disable]
      #--enable-directfb      build with DirectFB support [autodetect]
      #--enable-zr            build with ZR360[56]7/ZR36060 support [autodetect]
      #--enable-bl            build with Blinkenlights support [disable]
      #--enable-tdfxvid       build with tdfx_vid support [disable]
      #--disable-tga          disable targa output support [enable]
      #--disable-pnm          disable pnm output support [enable]
      #--disable-md5sum       disable md5sum output support [enable]


      # Audio Output (they are all autodetect but adding the enable flag will show \
      #               wrong cofigured libraries I hope)
        # the ones beeing commented out I don't know exactly which libraries they need?
        alsa = { cfgOption = "--enable-alsa";  buildInputs = "alsaLib"; };
        #oss = { cfgOption = "--enable-oss"; buildInputs = "oss"; };
        #arts = { cfgOption = "--enable-arts"; buildInputs = "arts"; };
        esd = { cfgOption = "--enable-esd"; buildInputs = "esound"; };
        #polyp = { cfgOption = "--enable-polyp"; buildInputs = "polyp"; };
        #jack = { cfgOption = "--enable-jack"; buildInputs = "jack"; };
        #openal = { cfgOption = "--enable-openal"; buildInputs = "openal"; };
        #nas = { cfgOption = "--enable-nas"; buildInputs = "nas"; };
        #sgiaudio = { cfgOption = "--enable-sgiaudio"; buildInputs = "sgiaudio"; };
        #sunaudio = { cfgOption = "--enable-sunaudio"; buildInputs = "sunaudio"; };
        #win32waveout = { cfgOption = "--enable-win32waveout"; buildInputs = "win32waveout"; };

        disableSelect = { cfgOption = "--disable-select"; }; # disable using select() on audio device [enable]

      #Miscellaneous options:
        #--enable-runtime-cpudetection    Enable runtime CPU detection [disable]
        #--enable-cross-compile Enable cross-compilation [autodetect]
        #--cc=COMPILER          use this C compiler to build MPlayer [gcc]
        #--host-cc=COMPILER     use this C compiler to build apps needed for the build process [gcc]
        #--as=ASSEMBLER         use this assembler to build MPlayer [as]
        #--target=PLATFORM      target platform (i386-linux, arm-linux, etc)
        #--enable-static        build a statically linked binary. Set further linking
                               #options with --enable-static="-lslang -lncurses"
        #--charset              convert the help messages to this charset
        #--language=list        a white space or comma separated list of languages
                               #for translated man pages, the first language is the
                               #primary and therefore used for translated messages
                               #and GUI (also the environment variable $LINGUAS is
                               #honored) [en]
                               #(Available: bg cs de dk el en es fr hu it ja ko mk nb nl pl ro ru sk sv tr uk pt_BR zh
      #_CN zh_TW all)

    };
    optionals = [ "esound" "alsa" "xv" "theora" "caca" "xinerama" "libXrandr" "esd" ];
  };

in args.stdenv.mkDerivation {

  inherit (co) buildInputs;

  name = "MPlayer-1.0rc1try2NewConfig";
  #name = "MPlayer-snapshot";

  #src = fetchurl {
  #  url = http://www7.mplayerhq.hu/MPlayer/releases/mplayer-checkout-snapshot.tar.bz2;
  #  sha1 = "529682cdea4f412d35f2c456897ab8808810975c";
  #};

  src = fetchurl {
    url = http://www1.mplayerhq.hu/MPlayer/releases/MPlayer-1.0rc1.tar.bz2;
    sha1 = "a450c0b0749c343a8496ba7810363c9d46dfa73c";
  };

  configurePhase = "./configure --prefix=\$out " + co.configureFlags
    # FIXME to which options do these settings belong?
    + " --with-win32libdir=${win32codecs}"
    + " --with-reallibdir=${win32codecs}"
    + " --enable-runtime-cpudetection"
    + " --enable-x11"
    + " --with-x11libdir=/no-such-dir"
    + " --with-extraincdir=${libX11}/include"
    + " --disable-xanim";

  # Provide a reasonable standard font.  Maybe we should symlink here.
  postInstall = "cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf";

  patches = [
   # These fix MPlayer's aspect ratio when run in a screen rotated with
   # Xrandr.
   # See: http://itdp.de/~itdp/html/mplayer-dev-eng/2005-08/msg00427.html
   ./mplayer-aspect.patch
   ./mplayer-pivot.patch

   # Security fix.
   ./asmrules-fix.patch
  ];

  meta = {
    homepage = http://www.mplayerhq.hu/;
    description = "A movie player that supports many video formats";
    license = "GPL-2";
  };

}

{ lib, stdenv, fetchurl, fetchgit, vdr, alsa-lib, fetchFromGitHub
, libvdpau, libxcb, xcbutilwm, graphicsmagick, libav, pcre, xorgserver, ffmpeg
, libiconv, boost, libgcrypt, perl, util-linux, groff, libva, xorg, ncurses
, callPackage
}: let
  mkPlugin = name: stdenv.mkDerivation {
    name = "vdr-${vdr.version}-${name}";
    inherit (vdr) src;
    buildInputs = [ vdr ];
    preConfigure = "cd PLUGINS/src/${name}";
    installFlags = [ "DESTDIR=$(out)" ];
  };
in {

  xineliboutput = callPackage ./xineliboutput {};

  skincurses = (mkPlugin "skincurses").overrideAttrs(oldAttr: {
    buildInputs = oldAttr.buildInputs ++ [ ncurses ];
  });

  inherit (lib.genAttrs [
    "epgtableid0" "hello" "osddemo" "pictures" "servicedemo" "status" "svdrpdemo"
  ] mkPlugin);

  femon = stdenv.mkDerivation rec {
    pname = "vdr-femon";
    version = "2.4.0";

    buildInputs = [ vdr ];

    src = fetchurl {
      url = "http://www.saunalahti.fi/~rahrenbe/vdr/femon/files/${pname}-${version}.tgz";
      sha256 = "1hra1xslj8s68zbyr8zdqp8yap0aj1p6rxyc6cwy1j122kwcnapp";
    };

    postPatch = "substituteInPlace Makefile --replace /bin/true true";

    makeFlags = [ "DESTDIR=$(out)" ];

    meta = with lib; {
      homepage = "http://www.saunalahti.fi/~rahrenbe/vdr/femon/";
      description = "DVB Frontend Status Monitor plugin for VDR";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  vaapidevice = stdenv.mkDerivation {
    pname = "vdr-vaapidevice";
    version = "20190525";

    buildInputs = [
      vdr libxcb xcbutilwm ffmpeg
      alsa-lib
      libvdpau # vdpau
      libva # va-api
    ] ++ (with xorg; [ libxcb libX11 ]);

    makeFlags = [ "DESTDIR=$(out)" ];

    postPatch = ''
      substituteInPlace vaapidev.c --replace /usr/bin/X ${xorgserver}/bin/X
      # https://github.com/rofafor/vdr-plugin-vaapidevice/issues/5
      substituteInPlace Makefile --replace libva libva-x11
    '';

    src = fetchFromGitHub {
      owner = "pesintta";
      repo = "vdr-plugin-vaapidevice";
      sha256 = "1gwjp15kjki9x5742fhaqk3yc2bbma74yp2vpn6wk6kj46nbnwp6";
      rev = "d19657bae399e79df107e316ca40922d21393f80";
    };

    meta = with lib; {
      homepage = "https://github.com/pesintta/vdr-plugin-vaapidevice";
      description = "VDR SoftHDDevice Plug-in (with VA-API VPP additions)";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };


  markad = stdenv.mkDerivation rec {
    pname = "vdr-markad";
    version = "unstable-2017-03-13";

    src = fetchgit {
      url = "git://projects.vdr-developer.org/vdr-plugin-markad.git";
      sha256 = "0jvy70r8bcmbs7zdqilfz019z5xkz5c6rs57h1dsgv8v6x86c2i4";
      rev = "ea2e182ec798375f3830f8b794e7408576f139ad";
    };

    buildInputs = [ vdr libav ];

    postPatch = ''
      substituteInPlace command/Makefile --replace '$(DESTDIR)/usr' '$(DESTDIR)'

      substituteInPlace plugin/markad.cpp \
        --replace "/usr/bin" "$out/bin" \
        --replace "/var/lib/markad" "$out/var/lib/markad"

      substituteInPlace command/markad-standalone.cpp \
        --replace "/var/lib/markad" "$out/var/lib/markad"
    '';

    preBuild = ''
      mkdir -p $out/lib/vdr
    '';

    buildFlags = [
      "DESTDIR=$(out)"
      "LIBDIR=$(out)/lib/vdr"
      "VDRDIR=${vdr.dev}/include/vdr"
      "LOCALEDIR=$(DESTDIR)/share/locale"
    ];

    installFlags = buildFlags;

    meta = with lib; {
      homepage = "https://projects.vdr-developer.org/projects/plg-markad";
      description = "Ein Programm zum automatischen Setzen von Schnittmarken bei Werbeeinblendungen während einer Sendung.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  epgsearch = stdenv.mkDerivation rec {
    pname = "vdr-epgsearch";
    version = "2.4.1";

    src = fetchgit {
      url = "git://projects.vdr-developer.org/vdr-plugin-epgsearch.git";
      sha256 = "sha256-UlbPCkUFN0Gyxjw9xq2STFTDZRVcPPNjadSQd4o2o9U=";
      rev = "v${version}";
    };

    postPatch = ''
      for f in *.sh; do
        patchShebangs "$f"
      done
    '';

    nativeBuildInputs = [
      perl # for pod2man and pos2html
      util-linux
      groff
    ];

    buildInputs = [
      vdr
      pcre
    ];

    buildFlags = [
      "SENDMAIL="
      "REGEXLIB=pcre"
    ];

    installFlags = [
      "DESTDIR=$(out)"
    ];

    outputs = [ "out" "man" ];

    meta = with lib; {
      homepage = "http://winni.vdr-developer.org/epgsearch";
      description = "Searchtimer and replacement of the VDR program menu";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  vnsiserver = stdenv.mkDerivation rec {
    pname = "vdr-vnsiserver";
    version = "1.8.0";

    buildInputs = [ vdr ];

    installFlags = [ "DESTDIR=$(out)" ];

    src = fetchFromGitHub {
      repo = "vdr-plugin-vnsiserver";
      owner = "FernetMenta";
      rev = "v${version}";
      sha256 = "0n7idpxqx7ayd63scl6xwdx828ik4kb2mwz0c30cfjnmnxxd45lw";
    };

    meta = with lib; {
      homepage = "https://github.com/FernetMenta/vdr-plugin-vnsiserver";
      description = "VDR plugin to handle KODI clients.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  text2skin = stdenv.mkDerivation {
    pname = "vdr-text2skin";
    version = "1.3.4-20170702";

    src = fetchgit {
      url = "git://projects.vdr-developer.org/vdr-plugin-text2skin.git";
      sha256 = "19hkwmaw6nwak38bv6cm2vcjjkf4w5yjyxb98qq6zfjjh5wq54aa";
      rev = "8f7954da2488ced734c30e7c2704b92a44e6e1ad";
    };

    buildInputs = [ vdr graphicsmagick ];

    buildFlags = [
      "DESTDIR=$(out)"
      "IMAGELIB=graphicsmagic"
      "VDRDIR=${vdr.dev}/include/vdr"
      "LOCALEDIR=$(DESTDIR)/share/locale"
      "LIBDIR=$(DESTDIR)/lib/vdr"
    ];

    preBuild = ''
      mkdir -p $out/lib/vdr
    '';

    dontInstall = true;

    meta = with lib; {
      homepage = "https://projects.vdr-developer.org/projects/plg-text2skin";
      description = "VDR Text2Skin Plugin";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };

  fritzbox = stdenv.mkDerivation rec {
    pname = "vdr-fritzbox";
    version = "1.5.4";

    src = fetchFromGitHub {
      owner = "jowi24";
      repo = "vdr-fritz";
      rev = version;
      sha256 = "sha256-DGD73i+ZHFgtCo+pMj5JaMovvb5vS1x20hmc5t29//o=";
      fetchSubmodules = true;
    };

    buildInputs = [ vdr boost libgcrypt ];

    installFlags = [ "DESTDIR=$(out)" ];

    meta = with lib; {
      homepage = "https://github.com/jowi24/vdr-fritz";
      description = "A plugin for VDR to access AVMs Fritz Box routers";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };
}

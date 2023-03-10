{ lib, stdenv, vdr, fetchFromGitHub
, graphicsmagick, pcre, xorgserver, ffmpeg
, libiconv, boost, libgcrypt, perl, util-linux, groff, libva, xorg, ncurses
, callPackage
}: let
  mkPlugin = name: stdenv.mkDerivation {
    name = "vdr-${name}-${vdr.version}";
    inherit (vdr) src;
    buildInputs = [ vdr ];
    preConfigure = "cd PLUGINS/src/${name}";
    installFlags = [ "DESTDIR=$(out)" ];
  };
in {

  softhddevice = callPackage ./softhddevice {};

  streamdev = callPackage ./streamdev {};

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

    src = fetchFromGitHub {
      repo = "vdr-plugin-femon";
      owner = "rofafor";
      sha256 = "sha256-0qBMYgNKk7N9Bj8fAoOokUo+G9gfj16N5e7dhoKRBqs=";
      rev = "v${version}";
    };

    postPatch = "substituteInPlace Makefile --replace /bin/true true";

    makeFlags = [ "DESTDIR=$(out)" ];

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "DVB Frontend Status Monitor plugin for VDR";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };

  };

  markad = stdenv.mkDerivation rec {
    pname = "vdr-markad";
    version = "3.1.1";

    src = fetchFromGitHub {
      repo = "vdr-plugin-markad";
      owner = "kfb77";
      sha256 = "sha256-h2a400T6mHzZRWAVFXF5Wzhu4Zp1D3btEKlxnCtB13M=";
      rev = "V${version}";
    };

    buildInputs = [ vdr ffmpeg ];

    postPatch = ''
      substituteInPlace command/Makefile --replace '/usr' ""

      substituteInPlace plugin/markad.cpp \
        --replace "/usr/bin" "$out/bin" \
        --replace "/var/lib/markad" "$out/var/lib/markad"

      substituteInPlace command/markad-standalone.cpp \
        --replace "/var/lib/markad" "$out/var/lib/markad"
    '';

    buildFlags = [
      "DESTDIR=$(out)"
      "LIBDIR=/lib/vdr"
      "BINDIR=/bin"
      "MANDIR=/share/man"
      "APIVERSION=${vdr.version}"
      "VDRDIR=${vdr.dev}/include/vdr"
      "LOCDIR=/share/locale"
    ];

    installFlags = buildFlags;

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "MarkAd marks advertisements in VDR recordings.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };

  };

  epgsearch = stdenv.mkDerivation rec {
    pname = "vdr-epgsearch";
    version = "2.4.2";

    src = fetchFromGitHub {
      repo = "vdr-plugin-epgsearch";
      owner = "vdr-projects";
      sha256 = "sha256-C+WSdGTnDBTWLvpjG5GBaK8pYbht431nL5iaL/a0H4Y=";
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
      inherit (src.meta) homepage;
      description = "Searchtimer and replacement of the VDR program menu";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };

  };

  vnsiserver = stdenv.mkDerivation rec {
    pname = "vdr-vnsiserver";
    version = "1.8.3";

    buildInputs = [ vdr ];

    installFlags = [ "DESTDIR=$(out)" ];

    src = fetchFromGitHub {
      repo = "vdr-plugin-vnsiserver";
      owner = "vdr-projects";
      rev = version;
      sha256 = "sha256-ivHdzX90ozMXSvIc5OrKC5qHeK5W3TK8zyrN8mY3IhE=";
    };

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "VDR plugin to handle KODI clients.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };

  };

  text2skin = stdenv.mkDerivation rec {
    pname = "vdr-text2skin";
    version = "1.3.4-20170702";

    src = fetchFromGitHub {
      repo = "vdr-plugin-text2skin";
      owner = "vdr-projects";
      rev = "8f7954da2488ced734c30e7c2704b92a44e6e1ad";
      sha256 = "19hkwmaw6nwak38bv6cm2vcjjkf4w5yjyxb98qq6zfjjh5wq54aa";
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
      inherit (src.meta) homepage;
      description = "VDR Text2Skin Plugin";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
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
      inherit (src.meta) homepage;
      description = "A plugin for VDR to access AVMs Fritz Box routers";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      inherit (vdr.meta) platforms;
    };
  };
}

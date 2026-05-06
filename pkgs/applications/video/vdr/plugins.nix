{
  lib,
  stdenv,
  vdr,
  fetchFromGitHub,
  graphicsmagick,
  boost,
  libgcrypt,
  ncurses,
  callPackage,
}:
let
  mkPlugin =
    name:
    stdenv.mkDerivation {
      pname = name;
      inherit (vdr) src version;

      buildInputs = [ vdr ];
      preConfigure = "cd PLUGINS/src/${name}";
      installFlags = [ "DESTDIR=$(out)" ];
    };
in
{

  epgsearch = callPackage ./epgsearch { };

  markad = callPackage ./markad { };

  nopacity = callPackage ./nopacity { };

  softhddevice = callPackage ./softhddevice { };

  streamdev = callPackage ./streamdev { };

  xineliboutput = callPackage ./xineliboutput { };

  skincurses = (mkPlugin "skincurses").overrideAttrs (oldAttr: {
    buildInputs = oldAttr.buildInputs ++ [ ncurses ];
  });

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

    meta = {
      inherit (src.meta) homepage;
      description = "VDR plugin to handle KODI clients";
      maintainers = [ lib.maintainers.ck3d ];
      license = lib.licenses.gpl2;
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

    buildInputs = [
      vdr
      graphicsmagick
    ];

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

    meta = {
      inherit (src.meta) homepage;
      description = "VDR Text2Skin Plugin";
      maintainers = [ lib.maintainers.ck3d ];
      license = lib.licenses.gpl2;
      inherit (vdr.meta) platforms;
    };
  };

  fritzbox = stdenv.mkDerivation rec {
    pname = "vdr-fritzbox";
    version = "1.5.8";

    src = fetchFromGitHub {
      owner = "jowi24";
      repo = "vdr-fritz";
      rev = version;
      hash = "sha256-o+wJJCAOTg6pPScZ0iIiEWZyT2/++pLtuOppNeaXzmQ=";
      fetchSubmodules = true;
    };

    buildInputs = [
      vdr
      boost
      libgcrypt
    ];

    installFlags = [ "DESTDIR=$(out)" ];

    meta = {
      inherit (src.meta) homepage;
      description = "Plugin for VDR to access AVMs Fritz Box routers";
      maintainers = [ lib.maintainers.ck3d ];
      license = lib.licenses.gpl2;
      inherit (vdr.meta) platforms;
    };
  };
}
// (lib.genAttrs [
  "epgtableid0"
  "hello"
  "osddemo"
  "pictures"
  "servicedemo"
  "status"
  "svdrpdemo"
] mkPlugin)

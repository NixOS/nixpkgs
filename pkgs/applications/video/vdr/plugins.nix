{ stdenv, fetchurl, fetchgit, vdr, ffmpeg_2, alsaLib, fetchFromGitHub
, libvdpau, libxcb, xcbutilwm, graphicsmagick, libav, pcre, xorgserver, ffmpeg
, libiconv, boost, libgcrypt, perl, utillinux, groff, libva, xorg }:
{
  femon = stdenv.mkDerivation rec {

    name = "vdr-femon-2.4.0";

    buildInputs = [ vdr ];

    src = fetchurl {
      url = "http://www.saunalahti.fi/~rahrenbe/vdr/femon/files/${name}.tgz";
      sha256 = "1hra1xslj8s68zbyr8zdqp8yap0aj1p6rxyc6cwy1j122kwcnapp";
    };

    postPatch = "substituteInPlace Makefile --replace /bin/true true";

    makeFlags = [ "DESTDIR=$(out)" ];

    meta = with stdenv.lib; {
      homepage = http://www.saunalahti.fi/~rahrenbe/vdr/femon/;
      description = "DVB Frontend Status Monitor plugin for VDR";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  vaapidevice = stdenv.mkDerivation {

    name = "vdr-vaapidevice-0.7.0";

    buildInputs = [
      vdr libxcb xcbutilwm ffmpeg
      alsaLib
      libvdpau # vdpau
      libva # va-api
    ] ++ (with xorg; [ libxcb libX11 ]);

    makeFlags = [ "DESTDIR=$(out)" ];

    postPatch = ''
      substituteInPlace softhddev.c --replace /usr/bin/X ${xorgserver}/bin/X
    '';

    src = fetchFromGitHub {
      owner = "pesintta";
      repo = "vdr-plugin-vaapidevice";
      sha256 = "072y61fpkh3i2dragg0nsd4g3malgwxkwpdrb1ykdljyzf52s5hs";
      rev = "c99afc23a53e6d91f9afaa99af59b30e68e626a8";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/pesintta/vdr-plugin-vaapidevice;
      description = "VDR SoftHDDevice Plug-in (with VA-API VPP additions)";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };


  markad = stdenv.mkDerivation rec {
    name = "vdr-markad-2017-03-13";

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

    meta = with stdenv.lib; {
      homepage = https://projects.vdr-developer.org/projects/plg-markad;
      description = "Ein Programm zum automatischen Setzen von Schnittmarken bei Werbeeinblendungen während einer Sendung.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  epgsearch = stdenv.mkDerivation rec {
    pname = "vdr-epgsearch";
    version = "2.4.0";

    src = fetchurl {
      url = "https://projects.vdr-developer.org/git/vdr-plugin-epgsearch.git/snapshot/vdr-plugin-epgsearch-${version}.tar.bz2";
      sha256 = "0xfgn17vicyjwdf0rbkrik4q16mnfi305d4wmi8f0qk825pa0z3y";
    };

    postPatch = ''
      for f in *.sh; do
        patchShebangs "$f"
      done
    '';

    nativeBuildInputs = [
      perl # for pod2man and pos2html
      utillinux
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

    meta = with stdenv.lib; {
      homepage = http://winni.vdr-developer.org/epgsearch;
      description = "Searchtimer and replacement of the VDR program menu";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  vnsiserver = let
    name = "vnsiserver";
    version = "1.8.0";
  in stdenv.mkDerivation {
    name = "vdr-${name}-${version}";

    buildInputs = [ vdr ];

    installFlags = [ "DESTDIR=$(out)" ];

    src = fetchFromGitHub {
      repo = "vdr-plugin-${name}";
      owner = "FernetMenta";
      rev = "v${version}";
      sha256 = "0n7idpxqx7ayd63scl6xwdx828ik4kb2mwz0c30cfjnmnxxd45lw";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/FernetMenta/vdr-plugin-vnsiserver;
      description = "VDR plugin to handle KODI clients.";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };

  };

  text2skin = stdenv.mkDerivation rec {
    name = "vdr-text2skin-1.3.4-20170702";

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

    installPhase = ":";

    meta = with stdenv.lib; {
      homepage = https://projects.vdr-developer.org/projects/plg-text2skin;
      description = "VDR Text2Skin Plugin";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };

  fritzbox = let
    libconvpp = stdenv.mkDerivation {
      name = "jowi24-libconv++-20130216";
      propagatedBuildInputs = [ libiconv ];
      CXXFLAGS = "-std=gnu++11 -Os";
      src = fetchFromGitHub {
        owner = "jowi24";
        repo = "libconvpp";
        rev = "90769b2216bc66c5ea5e41a929236c20d367c63b";
        sha256 = "0bf0dwxrzd42l84p8nxcsjdk1gvzlhad93nsbn97z6kr61n4cr33";
      };
      installPhase = ''
        mkdir -p $out/lib $out/include/libconv++
        cp source.a $out/lib/libconv++.a
        cp *.h $out/include/libconv++
      '';
    };

    liblogpp = stdenv.mkDerivation {
      name = "jowi24-liblogpp-20130216";
      CXXFLAGS = "-std=gnu++11 -Os";
      src = fetchFromGitHub {
        owner = "jowi24";
        repo = "liblogpp";
        rev = "eee4046d2ae440974bcc8ceec00b069f0a2c62b9";
        sha256 = "01aqvwmwh5kk3mncqpim8llwha9gj5qq0c4cvqfn4h8wqi3d9l3p";
      };
      installPhase = ''
        mkdir -p $out/lib $out/include/liblog++
        cp source.a $out/lib/liblog++.a
        cp *.h $out/include/liblog++
      '';
    };

    libnetpp = stdenv.mkDerivation {
      name = "jowi24-libnet++-20180628";
      CXXFLAGS = "-std=gnu++11 -Os";
      src = fetchFromGitHub {
        owner = "jowi24";
        repo = "libnetpp";
        rev = "212847f0efaeffee8422059b8e202d844174aaf3";
        sha256 = "0vjl6ld6aj25rzxm26yjv3h2gy7gp7qnbinpw6sf1shg2xim9x0b";
      };
      installPhase = ''
        mkdir -p $out/lib $out/include/libnet++
        cp source.a $out/lib/libnet++.a
        cp *.h $out/include/libnet++
      '';
      buildInputs = [ boost liblogpp libconvpp ];
    };

    libfritzpp = stdenv.mkDerivation {
      name = "jowi24-libfritzpp-20131201";
      CXXFLAGS = "-std=gnu++11 -Os";
      src = fetchFromGitHub {
        owner = "jowi24";
        repo = "libfritzpp";
        rev = "ca19013c9451cbac7a90155b486ea9959ced0f67";
        sha256 = "0jk93zm3qzl9z96gfs6xl1c8ip8lckgbzibf7jay7dbgkg9kyjfg";
      };
      installPhase = ''
        mkdir -p $out/lib $out/include/libfritz++
        cp source.a $out/lib/libfritz++.a
        cp *.h $out/include/libfritz++
      '';
      propagatedBuildInputs = [ libgcrypt ];
      buildInputs = [ boost liblogpp libconvpp libnetpp ];
    };

  in stdenv.mkDerivation rec {
    pname = "vdr-fritzbox";

    version = "1.5.3";

    src = fetchFromGitHub {
      owner = "jowi24";
      repo = "vdr-fritz";
      rev = version;
      sha256 = "0wab1kyma9jzhm6j33cv9hd2a5d1334ghgdi2051nmr1bdcfcsw8";
    };

    postUnpack = ''
      cp ${libfritzpp}/lib/* $sourceRoot/libfritz++
      cp ${liblogpp}/lib/* $sourceRoot/liblog++
      cp ${libnetpp}/lib/* $sourceRoot/libnet++
      cp ${libconvpp}/lib/* $sourceRoot/libconv++
    '';

    buildInputs = [ vdr boost libconvpp libfritzpp libnetpp liblogpp ];

    installFlags = [ "DESTDIR=$(out)" ];

    meta = with stdenv.lib; {
      homepage = https://github.com/jowi24/vdr-fritz;
      description = "A plugin for VDR to access AVMs Fritz Box routers";
      maintainers = [ maintainers.ck3d ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };
}

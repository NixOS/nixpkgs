{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, which, perl, autoconf, automake, libtool, openssl, systemd, pam, fuse, libjpeg, libopus, nasm, xorg }:

let
  xorgxrdp = stdenv.mkDerivation rec {
    name = "xorgxrdp-${version}";
    version = "0.2.0";
  
    src = fetchFromGitHub {
      owner = "neutrinolabs";
      repo = "xorgxrdp";
      rev = "v${version}";
      sha256 = "125mv7lm2ns1gdgz6zf647d3pay8if8506rclb3312wwa5qfd2hn";
    };

    nativeBuildInputs = [ pkgconfig autoconf automake which libtool nasm ];

    buildInputs = [ xorg.xorgserver ];

    postPatch = ''
      # patch from Debian, allows to run xrdp daemon under unprivileged user
      substituteInPlace module/rdpClientCon.c \
        --replace 'g_sck_listen(dev->listen_sck);' 'g_sck_listen(dev->listen_sck); g_chmod_hex(dev->uds_data, 0x0660);'

      substituteInPlace configure.ac \
        --replace 'moduledir=`pkg-config xorg-server --variable=moduledir`' "moduledir=$out/lib/xorg/modules" \
        --replace 'sysconfdir="/etc"' "sysconfdir=$out/etc"
    '';

    preConfigure = "./bootstrap";

    configureFlags = [ "XRDP_CFLAGS=-I${xrdp.src}/common"  ];

    enableParallelBuilding = true;
  };

  xrdp = stdenv.mkDerivation rec {
    version = "0.9.1";
    rev = "0920933"; # Fixes https://github.com/neutrinolabs/xrdp/issues/609; not a patch on top of the official repo because "xorgxrdp.configureFlags" above includes "xrdp.src" which must be fixed already
    name = "xrdp-${version}.${rev}";
  
    src = fetchFromGitHub {
      owner = "volth";
      repo = "xrdp";
      rev = rev;
      fetchSubmodules = true;
      sha256 = "0a000h82728vp0abvjk2m03nqqiw2lky7kqk41b70cyd3bp0vdnz";
    };

    nativeBuildInputs = [ pkgconfig autoconf automake which libtool nasm ];

    buildInputs = [ openssl systemd pam fuse libjpeg libopus xorg.libX11 xorg.libXfixes xorg.libXrandr ];

    postPatch = ''
      substituteInPlace sesman/xauth.c --replace "xauth -q" "${xorg.xauth}/bin/xauth -q"
      substituteInPlace common/file_loc.h --replace /etc/xrdp $out/etc/xrdp --replace /usr/local $out
      substituteInPlace instfiles/xrdp.sh --replace /etc/xrdp $out/etc/xrdp --replace /usr/local $out
    '';

    preConfigure = ''
      (cd librfxcodec && ./bootstrap && ./configure --prefix=$out --enable-static --disable-shared)
      ./bootstrap
    '';
    dontDisableStatic = true;
    configureFlags = [ "--with-systemdsystemunitdir=./do-not-install" "--enable-ipv6" "--enable-jpeg" "--enable-fuse" "--enable-rfxcodec" "--enable-opus" ];

    installFlags = [ "DESTDIR=$(out)" "prefix=" ];

    postInstall = ''
      # remove generated keys as non-determenistic
      rm $out/etc/xrdp/{rsakeys.ini,key.pem,cert.pem}

      cp $src/keygen/openssl.conf $out/share/xrdp/openssl.conf

      substituteInPlace $out/etc/xrdp/sesman.ini --replace /etc/xrdp/pulse $out/etc/xrdp/pulse

      # remove all session types except Xorg (they are not supported by this setup)
      ${perl}/bin/perl -i -ne 'print unless /\[(X11rdp|Xvnc|console|vnc-any|sesman-any|rdp-any|neutrinordp-any)\]/ .. /^$/' $out/etc/xrdp/xrdp.ini
   
      # remove all session types and then add Xorg
      ${perl}/bin/perl -i -ne 'print unless /\[(X11rdp|Xvnc|Xorg)\]/ .. /^$/' $out/etc/xrdp/sesman.ini
   
      cat >> $out/etc/xrdp/sesman.ini <<EOF
   
      [Xorg]
      param=${xorg.xorgserver}/bin/Xorg
      param=-modulepath
      param=${xorgxrdp}/lib/xorg/modules,${xorg.xorgserver}/lib/xorg/modules
      ; the following two lines are needless after https://github.com/NixOS/nixpkgs/pull/21653
      param=-xkbdir
      param=${xorg.xkeyboardconfig}/share/X11/xkb
      param=-config
      param=${xorgxrdp}/etc/X11/xrdp/xorg.conf
      param=-noreset
      param=-nolisten
      param=tcp
      param=-logfile
      param=.xorgxrdp.%s.log
      EOF
    '';

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "An open source RDP server";
      homepage = https://github.com/neutrinolabs/xrdp;
      license = licenses.asl20;
      maintainers = [ maintainers.volth ];
      platforms = platforms.linux;
    };
  };
in xrdp

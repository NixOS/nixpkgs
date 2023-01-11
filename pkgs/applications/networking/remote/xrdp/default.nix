{ lib, stdenv, fetchFromGitHub, pkg-config, which, perl, autoconf, automake, libtool, openssl, systemd, pam, fuse, libjpeg, libopus, nasm, xorg }:

let
  xorgxrdp = stdenv.mkDerivation rec {
    pname = "xorgxrdp";
    version = "0.2.9";

    src = fetchFromGitHub {
      owner = "neutrinolabs";
      repo = "xorgxrdp";
      rev = "v${version}";
      sha256 = "1bhp5x47hajhinvglmc4vxxnpjvfjm6369njb3ghqfr7c5xypvzr";
    };

    nativeBuildInputs = [ pkg-config autoconf automake which libtool nasm ];

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
    version = "0.9.9";
    pname = "xrdp";

    src = fetchFromGitHub {
      owner = "volth";
      repo = "xrdp";
      rev = "refs/tags/runtime-cfg-path-${version}";  # Fixes https://github.com/neutrinolabs/xrdp/issues/609; not a patch on top of the official repo because "xorgxrdp.configureFlags" above includes "xrdp.src" which must be patched already
      fetchSubmodules = true;
      sha256 = "0ynj6pml4f38y8571ryhifza57wfqg4frdrjcwzw3fmryiznfm1z";
    };

    nativeBuildInputs = [ pkg-config autoconf automake which libtool nasm ];

    buildInputs = [ openssl systemd pam fuse libjpeg libopus xorg.libX11 xorg.libXfixes xorg.libXrandr ];

    postPatch = ''
      substituteInPlace sesman/xauth.c --replace "xauth -q" "${xorg.xauth}/bin/xauth -q"
    '';

    preConfigure = ''
      (cd librfxcodec && ./bootstrap && ./configure --prefix=$out --enable-static --disable-shared)
      ./bootstrap
    '';
    dontDisableStatic = true;
    configureFlags = [ "--with-systemdsystemunitdir=/var/empty" "--enable-ipv6" "--enable-jpeg" "--enable-fuse" "--enable-rfxcodec" "--enable-opus" ];

    installFlags = [ "DESTDIR=$(out)" "prefix=" ];

    postInstall = ''
      # remove generated keys (as non-determenistic) and upstart script
      rm $out/etc/xrdp/{rsakeys.ini,key.pem,cert.pem,xrdp.sh}

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

    meta = with lib; {
      description = "An open source RDP server";
      homepage = "https://github.com/neutrinolabs/xrdp";
      license = licenses.asl20;
      maintainers = [ ];
      platforms = platforms.linux;
      knownVulnerabilities = [
        "CVE-2020-4044"
        "CVE-2022-23468"
        "CVE-2022-23477"
        "CVE-2022-23478"
        "CVE-2022-23479"
        "CVE-2022-23480"
        "CVE-2022-23481"
        "CVE-2022-23482"
        "CVE-2022-23483"
        "CVE-2022-23484"
        "CVE-2022-23493"
        "CVE-2022-23613"
      ];
    };
  };
in xrdp

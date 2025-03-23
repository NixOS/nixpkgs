{
  lib,
  stdenv,
  applyPatches,
  fetchFromGitHub,
  pkg-config,
  which,
  perl,
  autoconf,
  automake,
  libtool,
  openssl,
  systemd,
  pam,
  fuse,
  libdrm,
  libjpeg,
  libopus,
  nasm,
  xorg,
  lame,
  pixman,
  libjpeg_turbo,
  _experimental-update-script-combinators,
  gitUpdater,
  nixosTests,
}:

let
  xorgxrdp = stdenv.mkDerivation rec {
    pname = "xorgxrdp";
    version = "0.10.2";

    src = fetchFromGitHub {
      owner = "neutrinolabs";
      repo = "xorgxrdp";
      rev = "v${version}";
      hash = "sha256-xwkGY9dD747kyTvoXrYAIoiFBzQe5ngskUYQhDawnbU=";
    };

    nativeBuildInputs = [
      pkg-config
      autoconf
      automake
      which
      libtool
      nasm
    ];

    buildInputs = [
      xorg.xorgserver
      libdrm
    ];

    postPatch = ''
      # patch from Debian, allows to run xrdp daemon under unprivileged user
      substituteInPlace module/rdpClientCon.c \
        --replace 'g_sck_listen(dev->listen_sck);' 'g_sck_listen(dev->listen_sck); g_chmod_hex(dev->uds_data, 0x0660);'

      substituteInPlace configure.ac \
        --replace 'moduledir=`pkg-config xorg-server --variable=moduledir`' "moduledir=$out/lib/xorg/modules" \
        --replace 'sysconfdir="/etc"' "sysconfdir=$out/etc"
    '';

    preConfigure = ''
      ./bootstrap
      export XRDP_CFLAGS="-I${xrdp.src}/common -I${libdrm.dev}/include -I${libdrm.dev}/include/libdrm"
    '';

    enableParallelBuilding = true;

    passthru.updateScript = gitUpdater { rev-prefix = "v"; };
  };

  xrdp = stdenv.mkDerivation rec {
    pname = "xrdp";
    version = "0.10.1";

    src = applyPatches {
      inherit version;
      patches = [ ./dynamic_config.patch ];
      name = "xrdp-patched-${version}";
      src = fetchFromGitHub {
        owner = "neutrinolabs";
        repo = "xrdp";
        rev = "v${version}";
        fetchSubmodules = true;
        hash = "sha256-lqifQJ/JX+0304arVctsEBEDFPhEPn2OWLyjAQW1who=";
      };
    };

    nativeBuildInputs = [
      pkg-config
      autoconf
      automake
      which
      libtool
      nasm
      perl
    ];

    buildInputs = [
      fuse
      lame
      libjpeg
      libjpeg_turbo
      libopus
      openssl
      pam
      pixman
      systemd
      xorg.libX11
      xorg.libXfixes
      xorg.libXrandr
    ];

    postPatch = ''
      substituteInPlace sesman/sesexec/xauth.c --replace "xauth -q" "${xorg.xauth}/bin/xauth -q"

      substituteInPlace configure.ac --replace /usr/include/ ""
    '';

    preConfigure = ''
      (cd librfxcodec && ./bootstrap && ./configure --prefix=$out --enable-static --disable-shared)
      ./bootstrap
    '';
    dontDisableStatic = true;
    configureFlags = [
      "--with-systemdsystemunitdir=/var/empty"
      "--enable-fuse"
      "--enable-ipv6"
      "--enable-jpeg"
      "--enable-mp3lame"
      "--enable-opus"
      "--enable-pam-config=unix"
      "--enable-pixman"
      "--enable-rdpsndaudin"
      "--enable-rfxcodec"
      "--enable-tjpeg"
      "--enable-vsock"
    ];

    installFlags = [
      "DESTDIR=$(out)"
      "prefix="
    ];

    postInstall = ''
      # remove generated keys (as non-deterministic)
      rm $out/etc/xrdp/{rsakeys.ini,key.pem,cert.pem}

      cp $src/keygen/openssl.conf $out/share/xrdp/openssl.conf

      substituteInPlace $out/etc/xrdp/sesman.ini --replace /etc/xrdp/pulse $out/etc/xrdp/pulse
      substituteInPlace $out/etc/xrdp/sesman.ini --replace '#SessionSockdirGroup=root' 'SessionSockdirGroup=xrdp'

      # remove all session types except Xorg (they are not supported by this setup)
      perl -i -ne 'print unless /\[(X11rdp|Xvnc|console|vnc-any|sesman-any|rdp-any|neutrinordp-any)\]/ .. /^$/' $out/etc/xrdp/xrdp.ini

      # remove all session types and then add Xorg
      perl -i -ne 'print unless /\[(X11rdp|Xvnc|Xorg)\]/ .. /^$/' $out/etc/xrdp/sesman.ini

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

    passthru = {
      inherit xorgxrdp;
      updateScript = _experimental-update-script-combinators.sequence (
        map (item: item.command) [
          (gitUpdater {
            rev-prefix = "v";
            attrPath = "xrdp.src";
            ignoredVersions = [ "beta" ];
          })
          {
            command = [
              "rm"
              "update-git-commits.txt"
            ];
          }
          (gitUpdater {
            rev-prefix = "v";
            attrPath = "xrdp.xorgxrdp";
          })
        ]
      );
      tests = {
        inherit (nixosTests) xrdp;
      };
    };

    meta = with lib; {
      description = "Open source RDP server";
      homepage = "https://github.com/neutrinolabs/xrdp";
      license = licenses.asl20;
      maintainers = with maintainers; [
        chvp
        lucasew
      ];
      platforms = platforms.linux;
    };
  };
in
xrdp

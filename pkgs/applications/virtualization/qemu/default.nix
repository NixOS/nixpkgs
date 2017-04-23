{ stdenv, fetchurl, fetchpatch, python2, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl
, makeWrapper
, attr, libcap, libcap_ng
, CoreServices, Cocoa, rez, setfile
, numaSupport ? stdenv.isLinux, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, sdlSupport ? !stdenv.isDarwin, SDL
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? !stdenv.isDarwin, spice, spice_protocol, usbredir
, x86Only ? false
, nixosTestRunner ? false
}:

with stdenv.lib;
let
  version = "2.8.1.1";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";
in

stdenv.mkDerivation rec {
  name = "qemu-"
    + stdenv.lib.optionalString x86Only "x86-only-"
    + stdenv.lib.optionalString nixosTestRunner "for-vm-tests-"
    + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "0f1nbnjpsy6v3ca1hxkpzwg5h4avjk6bwi7dh565pzxr3y5b2apn";
  };

  buildInputs =
    [ python2 zlib pkgconfig glib ncurses perl pixman
      vde2 texinfo flex bison makeWrapper lzo snappy
      gnutls nettle curl
    ]
    ++ optionals stdenv.isDarwin [ CoreServices Cocoa rez setfile ]
    ++ optionals seccompSupport [ libseccomp ]
    ++ optionals numaSupport [ numactl ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals spiceSupport [ spice_protocol spice usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ];

  enableParallelBuilding = true;

  patches = let
    upstreamPatch = name: commit: sha256: fetchurl {
      name = "${name}.patch";
      url = "http://git.qemu-project.org/?p=qemu.git;a=patch;h=${commit}";
      inherit sha256;
    };
  in [
    ./no-etc-install.patch

    # bugfixes
    # xhci: fix event queue IRQ handling
    (upstreamPatch "qemu-fix-win7-xhci" "7da76e12cc5cc902dda4c168d8d608fd4e61cbc5"
      "0m1ggbxziy7vqz9007ypzg23cni8cc4db36wlnhxz0kdpq70c6x0")

    # xhci: only free completed transfers
    (upstreamPatch "qemu-xhci-free-completed-transfers" "f94d18d6c6df388fde196d3ab252f57e33843a8b"
      "0lk19qss6ky7cqnvis54742cr2z0vl8c64chhch0kp6n83hray9x")

    # security fixes from upstream
    # net: imx: limit buffer descriptor count
    (upstreamPatch "CVE-2016-7907" "81f17e0d435c3db3a3e67e0d32ebf9c98973211f"
      "0dzghbm3jmnyw34kd40a6akrr1cpizd9hdzqmhlc2ljab7pr1rcb")

    # watchdog: 6300esb: add exit function
    (upstreamPatch "CVE-2016-10155" "eb7a20a3616085d46aa6b4b4224e15587ec67e6e"
      "1xk00fyls0hdza11dyfrnzcn6gibmmcrwy7sxgp6iizp6wgzi3vw")

    # audio: ac97: add exit function
    (upstreamPatch "CVE-2017-5525" "12351a91da97b414eec8cdb09f1d9f41e535a401"
      "190b4aqr35p4lb3rjarknfi1ip1c9zizliqp1dd6frx4364y5yp2")

    # audio: es1370: add exit function
    (upstreamPatch "CVE-2017-5526" "069eb7b2b8fc47c7cb52e5a4af23ea98d939e3da"
      "05xgzd3zldk3x2vqpjag9z5ilhdkpkyh633fb5kvnz8scns6v86f")

    # serial: fix memory leak in serial exit
    (upstreamPatch "CVE-2017-5579" "8409dc884a201bf74b30a9d232b6bbdd00cb7e2b"
      "0lbcyhif1kdcy8my0bv8aqr2f421kmljcch3plrjzj9pgcm4sv83")

    # megasas: fix guest-triggered memory leak
    (upstreamPatch "CVE-2017-5856" "765a707000e838c30b18d712fe6cb3dd8e0435f3"
      "03pjkn8l8rp9ip5h5rm1dp0nrwd43nmgpwamz4z1vy3rli1z3yjw")

    # virtio-gpu: fix resource leak in virgl_cmd_resource_unref
    (upstreamPatch "CVE-2017-5857" "5e8e3c4c75c199aa1017db816fca02be2a9f8798"
      "1kz14rmxf049zl5m27apzpbvy8dk0g47n9gnwy0nm70g65rl1dh8")

    # usb: ccid: check ccid apdu length
    (upstreamPatch "CVE-2017-5898" "c7dfbf322595ded4e70b626bf83158a9f3807c6a"
      "1y2j0qw04s8fl0cs8i619y08kj75lxn3c0y19g710fzpk3rq8dvn")

    # xhci: apply limits to loops
    (upstreamPatch "CVE-2017-5973" "f89b60f6e5fee3923bedf80e82b4e5efc1bb156b"
      "06niyighjxb4p5z2as3mqfmrwrzn4sq47j7raipbq9gnda7x9sw6")

    # sd: sdhci: check transfer mode register in multi block transfer
    (upstreamPatch "CVE-2017-5987" "6e86d90352adf6cb08295255220295cf23c4286e"
      "09yfxf93cisx8rhm0h48ib1ibwfs420k5pqpz8dnz33nci9567jm")

  ] ++ optional nixosTestRunner ./force-uid0-on-9p.patch;

  hardeningDisable = [ "stackprotector" ];

  configureFlags =
    [ "--smbd=smbd" # use `smbd' from $PATH
      "--audio-drv-list=${audio}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional spiceSupport "--enable-spice"
    ++ optional x86Only "--target-list=i386-softmmu,x86_64-softmmu"
    ++ optional stdenv.isDarwin "--enable-cocoa"
    ++ optional stdenv.isLinux "--enable-linux-aio";

  postFixup =
    ''
      for exe in $out/bin/qemu-system-* ; do
        paxmark m $exe
      done
    '';

  postInstall =
    ''
      # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
      p="$out/bin/qemu-system-${if stdenv.system == "x86_64-linux" then "x86_64" else "i386"}"
      if [ -e "$p" ]; then
        makeWrapper "$p" $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"
      fi
    '';

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric eelco ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

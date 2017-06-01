{ stdenv, callPackage, fetchurl, fetchpatch, fetchgit
, withInternalQemu ? true
, withInternalTraditionalQemu ? true
, withInternalSeabios ? true
, withSeabios ? !withInternalSeabios, seabios ? null
, withInternalOVMF ? false # FIXME: tricky to build
, withOVMF ? false, OVMF
, withLibHVM ? true

# qemu
, udev, pciutils, xorg, SDL, pixman, acl, glusterfs, spice_protocol, usbredir
, alsaLib
, ... } @ args:

assert withInternalSeabios -> !withSeabios;
assert withInternalOVMF -> !withOVMF;

with stdenv.lib;

# Patching XEN? Check the XSAs at
# https://xenbits.xen.org/xsa/
# and try applying all the ones we don't have yet.

let
  xsaPatch = { name , sha256 }: (fetchpatch {
    url = "https://xenbits.xen.org/xsa/xsa${name}.patch";
    inherit sha256;
  });

  qemuDeps = [
    udev pciutils xorg.libX11 SDL pixman acl glusterfs spice_protocol usbredir
    alsaLib
  ];
in

callPackage (import ./generic.nix (rec {
  version = "4.5.5";

  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "1y74ms4yc3znf8jc3fgyq94va2y0pf7jh8m9pfqnpgklywqnw8g2";
  };

  # Sources needed to build tools and firmwares.
  xenfiles = optionalAttrs withInternalQemu {
    "qemu-xen" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/qemu-xen.git;
        rev = "refs/tags/qemu-xen-${version}";
        sha256 = "014s755slmsc7xzy7qhk9i3kbjr2grxb5yznjp71dl6xxfvnday2";
      };
      buildInputs = qemuDeps;
      patches = [
        (xsaPatch {
          name = "197-4.5-qemuu";
          sha256 = "09gp980qdlfpfmxy0nk7ncyaa024jnrpzx9gpq2kah21xygy5myx";
        })
        (xsaPatch {
          name = "208-qemuu-4.7";
          sha256 = "0z9b1whr8rp2riwq7wndzcnd7vw1ckwx0vbk098k2pcflrzppgrb";
        })
        (xsaPatch {
          name = "209-qemuu/0001-display-cirrus-ignore-source-pitch-value-as-needed-i";
          sha256 = "1xvxzsrsq05fj6szjlpbgg4ia3cw54dn5g7xzq1n1dymbhv606m0";
        })
        (xsaPatch {
          name = "209-qemuu/0002-cirrus-add-blit_is_unsafe-call-to-cirrus_bitblt_cput";
          sha256 = "0avxqs9922qjfsxxlk7bh10432a526j2yyykhags8dk1bzxkpxwv";
        })
      ];
      meta.description = "Xen's fork of upstream Qemu";
    };
  } // optionalAttrs withInternalTraditionalQemu {
    "qemu-xen-traditional" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/qemu-xen-traditional.git;
        rev = "refs/tags/xen-${version}";
        sha256 = "0n0ycxlf1wgdjkdl8l2w1i0zzssk55dfv67x8i6b2ima01r0k93r";
      };
      buildInputs = qemuDeps;
      patches = [
        (xsaPatch {
          name = "197-4.5-qemut";
          sha256 = "17l7npw00gyhqzzaqamwm9cawfvzm90zh6jjyy95dmqbh7smvy79";
        })
        (xsaPatch {
          name = "199-trad";
          sha256 = "0dfw6ciycw9a9s97sbnilnzhipnzmdm9f7xcfngdjfic8cqdcv42";
        })
        (xsaPatch {
          name = "208-qemut";
          sha256 = "0960vhchixp60j9h2lawgbgzf6mpcdk440kblk25a37bd6172l54";
        })
        (xsaPatch {
          name = "209-qemut";
          sha256 = "1hq8ghfzw6c47pb5vf9ngxwgs8slhbbw6cq7gk0nam44rwvz743r";
        })
      ];
      postPatch = ''
        substituteInPlace xen-hooks.mak \
          --replace /usr/include/pci ${pciutils}/include/pci
      '';
      meta.description = "Xen's fork of upstream Qemu that uses old device model";
    };
  } // optionalAttrs withInternalSeabios {
    "firmware/seabios-dir-remote" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/seabios.git;
        rev = "e51488c5f8800a52ac5c8da7a31b85cca5cc95d2";
        #rev = "rel-1.7.5";
        sha256 = "0jk54ybhmw97pzyhpm6jr2x99f702kbn0ipxv5qxcbynflgdazyb";
      };
      patches = [ ./0000-qemu-seabios-enable-ATA_DMA.patch ];
      meta.description = "Xen's fork of Seabios";
    };
  } // optionalAttrs withInternalOVMF {
    "firmware/ovmf-dir-remote" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/ovmf.git;
        rev = "cb9a7ebabcd6b8a49dc0854b2f9592d732b5afbd";
        sha256 = "07zmdj90zjrzip74fvd4ss8n8njk6cim85s58mc6snxmqqv7gmcq";
      };
      meta.description = "Xen's fork of OVMF";
    };
  } // {
    # TODO: patch Xen to make this optional?
    "firmware/etherboot/ipxe.git" = {
      src = fetchgit {
        url = https://git.ipxe.org/ipxe.git;
        rev = "9a93db3f0947484e30e753bbd61a10b17336e20e";
        sha256 = "1ga3h1b34q0cl9azj7j9nswn7mfcs3cgfjdihrm5zkp2xw2hpvr6";
      };
      meta.description = "Xen's fork of iPXE";
    };
  } // optionalAttrs withLibHVM {
    "xen-libhvm-dir-remote" = {
      src = fetchgit {
        name = "xen-libhvm";
        url = https://github.com/ts468/xen-libhvm;
        rev = "442dcc4f6f4e374a51e4613532468bd6b48bdf63";
        sha256 = "9ba97c39a00a54c154785716aa06691d312c99be498ebbc00dc3769968178ba8";
      };
      buildPhase = ''
        make
        cd biospt
        cc -Wall -g -D_LINUX -Wstrict-prototypes biospt.c -o biospt -I../libhvm -L../libhvm -lxenhvm
      '';
      installPhase = ''
        make install
        cp biospt/biospt $out/bin/
      '';
      meta = {
        description = ''
          Helper library for reading ACPI and SMBIOS firmware values
          from the host system for use with the HVM guest firmware
          pass-through feature in Xen'';
        license = licenses.bsd2;
      };
    };
  };

  configureFlags = []
    ++ optional (!withInternalQemu) "--with-system-qemu" # use qemu from PATH
    ++ optional (withInternalTraditionalQemu) "--enable-qemu-traditional"
    ++ optional (!withInternalTraditionalQemu) "--disable-qemu-traditional"

    ++ optional (withSeabios) "--with-system-seabios=${seabios}"
    ++ optional (!withInternalSeabios && !withSeabios) "--disable-seabios"

    ++ optional (withOVMF) "--with-system-ovmf=${OVMF.fd}/FV/OVMF.fd"
    ++ optional (withInternalOVMF) "--enable-ovmf";

  patches =
    [ ./0001-libxl-Spice-image-compression-setting-support-for-up.patch
      ./0002-libxl-Spice-streaming-video-setting-support-for-upst.patch
      ./0003-Add-qxl-vga-interface-support-for-upstream-qem.patch
      (xsaPatch {
        name = "190-4.5";
        sha256 = "0f8pw38kkxky89ny3ic5h26v9zsjj9id89lygx896zc3w1klafqm";
      })
      (xsaPatch {
        name = "191-4.6";
        sha256 = "1wl1ndli8rflmc44pkp8cw4642gi8z7j7gipac8mmlavmn3wdqhg";
      })
      (xsaPatch {
        name = "192-4.5";
        sha256 = "0m8cv0xqvx5pdk7fcmaw2vv43xhl62plyx33xqj48y66x5z9lxpm";
      })
      (xsaPatch {
        name = "193-4.5";
        sha256 = "0k9mykhrpm4rbjkhv067f6s05lqmgnldcyb3vi8cl0ndlyh66lvr";
      })
      (xsaPatch {
        name = "195";
        sha256 = "0m0g953qnjy2knd9qnkdagpvkkgjbk3ydgajia6kzs499dyqpdl7";
      })
      (xsaPatch {
        name = "196-0001-x86-emul-Correct-the-IDT-entry-calculation-in-inject";
        sha256 = "0z53nzrjvc745y26z1qc8jlg3blxp7brawvji1hx3s74n346ssl6";
      })
      (xsaPatch {
        name = "196-0002-x86-svm-Fix-injection-of-software-interrupts";
        sha256 = "11cqvr5jn2s92wsshpilx9qnfczrd9hnyb5aim6qwmz3fq3hrrkz";
      })
      (xsaPatch {
        name = "198";
        sha256 = "0d1nndn4p520c9xa87ixnyks3mrvzcri7c702d6mm22m8ansx6d9";
      })
      (xsaPatch {
        name = "200-4.6";
        sha256 = "0k918ja83470iz5k4vqi15293zjvz2dipdhgc9sy9rrhg4mqncl7";
      })
      (xsaPatch {
        name = "202-4.6";
        sha256 = "0nnznkrvfbbc8z64dr9wvbdijd4qbpc0wz2j5vpmx6b32sm7932f";
      })
      (xsaPatch {
        name = "204-4.5";
        sha256 = "083z9pbdz3f532fnzg7n2d5wzv6rmqc0f4mvc3mnmkd0rzqw8vcp";
      })
      (xsaPatch {
        name = "207";
        sha256 = "0wdlhijmw9mdj6a82pyw1rwwiz605dwzjc392zr3fpb2jklrvibc";
      })
    ];

  # Fix build on Glibc 2.24.
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postPatch = ''
    # Avoid a glibc >= 2.25 deprecation warnings that get fatal via -Werror.
    sed 1i'#include <sys/sysmacros.h>' \
      -i tools/blktap2/control/tap-ctl-allocate.c \
      -i tools/libxl/libxl_device.c
  '';

})) args

{ stdenv, callPackage, fetchurl, fetchpatch, fetchgit
, ocamlPackages_4_02
, withInternalQemu ? true
, withInternalTraditionalQemu ? true
, withInternalSeabios ? true
, withSeabios ? !withInternalSeabios, seabios ? null
, withInternalOVMF ? false # FIXME: tricky to build
, withOVMF ? false, OVMF
, withLibHVM ? true

# qemu
, udev, pciutils, xorg, SDL, pixman, acl, glusterfs, spice-protocol, usbredir
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
    udev pciutils xorg.libX11 SDL pixman acl glusterfs spice-protocol usbredir
    alsaLib
  ];

  xsa = import ./xsa-patches.nix { inherit fetchpatch; };
in

callPackage (import ./generic.nix (rec {
  version = "4.5.5";

  src = fetchurl {
    url = "https://downloads.xenproject.org/release/xen/${version}/xen-${version}.tar.gz";
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
        (xsaPatch {
          name = "211-qemuu-4.6";
          sha256 = "1g090xs8ca8676vyi78b99z5yjdliw6mxkr521b8kimhf8crx4yg";
        })
        (xsaPatch {
          name = "216-qemuu-4.5";
          sha256 = "0nh5akbal93czia1gh1pzvwq7gc4zwiyr1hbyk1m6wwdmqv6ph61";
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
        (xsaPatch {
          name = "211-qemut-4.5";
          sha256 = "1z3phabvqmxv4b5923fx63hwdg4v1fnl15zbl88873ybqn0hp50f";
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

  patches = with xsa; flatten [
    ./0001-libxl-Spice-image-compression-setting-support-for-up.patch
    ./0002-libxl-Spice-streaming-video-setting-support-for-upst.patch
    ./0003-Add-qxl-vga-interface-support-for-upstream-qem.patch
    XSA_190
    XSA_191
    XSA_192
    XSA_193
    XSA_195
    XSA_196
    XSA_198
    XSA_200
    XSA_202_45
    XSA_204_45
    XSA_206_45
    XSA_207
    XSA_212
    XSA_213_45
    XSA_214
    XSA_215
    XSA_217_45
    XSA_218_45
    XSA_219_45
    XSA_220_45
    XSA_221
    XSA_222_45
    XSA_223
    XSA_224_45
    XSA_227_45
    XSA_230
    XSA_231_45
    XSA_232
    XSA_233
    XSA_234_45
    XSA_235_45
    XSA_236_45
    XSA_237_45
    XSA_238_45
    XSA_239_45
    XSA_240_45
    XSA_241
    XSA_242
    XSA_243_45
    XSA_244_45
    XSA_245
    XSA_246_45
    XSA_247_45
    XSA_248_45
    XSA_249
    XSA_250_45
    XSA_251_45
  ];

  # Fix build on Glibc 2.24.
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postPatch = ''
    # Avoid a glibc >= 2.25 deprecation warnings that get fatal via -Werror.
    sed 1i'#include <sys/sysmacros.h>' \
      -i tools/blktap2/control/tap-ctl-allocate.c \
      -i tools/libxl/libxl_device.c
  '';

  passthru = {
    qemu-system-i386 = if withInternalQemu
      then "lib/xen/bin/qemu-system-i386"
      else throw "this xen has no qemu builtin";
  };

})) ({ ocamlPackages = ocamlPackages_4_02; } // args)

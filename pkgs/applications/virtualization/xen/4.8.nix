{ stdenv, callPackage, fetchurl, fetchpatch, fetchgit
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

  xsa = import ./xsa-patches.nix { inherit fetchpatch; };

  qemuDeps = [
    udev pciutils xorg.libX11 SDL pixman acl glusterfs spice-protocol usbredir
    alsaLib
  ];
in

callPackage (import ./generic.nix (rec {
  version = "4.8.2";

  src = fetchurl {
    url = "https://downloads.xenproject.org/release/xen/${version}/xen-${version}.tar.gz";
    sha256 = "1ydgwbn8ab0s16jrbi3wzaa6j0y3zk0j8pay458qcgayk3qc476b";
  };

  # Sources needed to build tools and firmwares.
  xenfiles = optionalAttrs withInternalQemu {
    "qemu-xen" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/qemu-xen.git;
        rev = "refs/tags/qemu-xen-${version}";
        sha256 = "1l4sygd8p0mc13bskr4r1m31qh1kr58h195qn1s52869s58jyhvm";
      };
      buildInputs = qemuDeps;
      meta.description = "Xen's fork of upstream Qemu";
    };
  } // optionalAttrs withInternalTraditionalQemu {
    "qemu-xen-traditional" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/qemu-xen-traditional.git;
        rev = "refs/tags/xen-${version}";
        sha256 = "0mryap5y53r09m7qc0b821f717ghwm654r8c3ik1w7adzxr0l5qk";
      };
      buildInputs = qemuDeps;
      patches = [
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
        rev = "f0cdc36d2f2424f6b40438f7ee7cc502c0eff4df";
        sha256 = "1wq5pjkjrfzqnq3wyr15mcn1l4c563m65gdyf8jm97kgb13pwwfm";
      };
      patches = [ ./0000-qemu-seabios-enable-ATA_DMA.patch ];
      meta.description = "Xen's fork of Seabios";
    };
  } // optionalAttrs withInternalOVMF {
    "firmware/ovmf-dir-remote" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/ovmf.git;
        rev = "173bf5c847e3ca8b42c11796ce048d8e2e916ff8";
        sha256 = "07zmdj90zjrzip74fvd4ss8n8njk6cim85s58mc6snxmqqv7gmcr";
      };
      meta.description = "Xen's fork of OVMF";
    };
  } // {
    # TODO: patch Xen to make this optional?
    "firmware/etherboot/ipxe.git" = {
      src = fetchgit {
        url = https://git.ipxe.org/ipxe.git;
        rev = "356f6c1b64d7a97746d1816cef8ca22bdd8d0b5d";
        sha256 = "15n400vm3id5r8y3k6lrp9ab2911a9vh9856f5gvphkazfnmns09";
      };
      meta.description = "Xen's fork of iPXE";
    };
  } // optionalAttrs withLibHVM {
    "xen-libhvm-dir-remote" = {
      src = fetchgit {
        name = "xen-libhvm";
        url = https://github.com/michalpalka/xen-libhvm;
        rev = "83065d36b36d6d527c2a4e0f5aaf0a09ee83122c";
        sha256 = "1jzv479wvgjkazprqdzcdjy199azmx2xl3pnxli39kc5mvjz3lzd";
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
    XSA_231
    XSA_232
    XSA_233
    XSA_234_48
    XSA_236
    XSA_237_48
    XSA_238
    XSA_239
    XSA_240_48
    XSA_241
    XSA_242
    XSA_243_48
    XSA_244
    XSA_245
    XSA_246
    XSA_247_48
    XSA_248_48
    XSA_249
    XSA_250
    XSA_251_48
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

})) args

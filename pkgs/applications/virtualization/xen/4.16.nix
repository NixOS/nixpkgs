{ lib, callPackage, fetchurl, fetchpatch, fetchgit
, ocaml-ng
, withInternalQemu ? true
, withInternalTraditionalQemu ? true
, withInternalSeabios ? true
, withSeabios ? !withInternalSeabios, seabios ? null
, withInternalOVMF ? false # FIXME: tricky to build
, withOVMF ? false, OVMF
, withLibHVM ? true

# qemu
, udev, pciutils, xorg, SDL, pixman, acl, glusterfs, spice-protocol, usbredir
, alsa-lib, glib, python2
, ... } @ args:

assert withInternalSeabios -> !withSeabios;
assert withInternalOVMF -> !withOVMF;

with lib;

# Patching XEN? Check the XSAs at
# https://xenbits.xen.org/xsa/
# and try applying all the ones we don't have yet.

let
  xsa = import ./xsa-patches.nix { inherit fetchpatch; };

  qemuMemfdBuildFix = fetchpatch {
    name = "xen-4.8-memfd-build-fix.patch";
    url = "https://github.com/qemu/qemu/commit/75e5b70e6b5dcc4f2219992d7cffa462aa406af0.patch";
    sha256 = "0gaz93kb33qc0jx6iphvny0yrd17i8zhcl3a9ky5ylc2idz0wiwa";
  };

  qemuDeps = [
    udev pciutils xorg.libX11 SDL pixman acl glusterfs spice-protocol usbredir
    alsa-lib glib python2
  ];
in

callPackage (import ./generic.nix (rec {
  version = "4.16.0";

  src = fetchurl {
    url = "https://downloads.xenproject.org/release/xen/${version}/xen-${version}.tar.gz";
    sha256 = "15g91rnjamdn7jdid79jpx476nl1inpfp6jb06i91l0lws87mj5d";
  };

  # Sources needed to build tools and firmwares.
  xenfiles = optionalAttrs withInternalQemu {
    qemu-xen = {
      src = fetchgit {
        url = "https://xenbits.xen.org/git-http/qemu-xen.git";
        # rev = "refs/tags/qemu-xen-${version}";
        # use revision hash - reproducible but must be updated with each new version
        rev = "qemu-xen-${version}";
        sha256 = "sha256-PNpsjkP3Y15k7gSQCC7PUuOdX0oB0B6YiTLH003/ejc=";
      };
      buildInputs = qemuDeps;
      postPatch = ''
        # needed in build but /usr/bin/env is not available in sandbox
        substituteInPlace scripts/tracetool.py \
          --replace "/usr/bin/env python" "${python2}/bin/python"
      '';
      meta.description = "Xen's fork of upstream Qemu";
    };
  } // optionalAttrs withInternalTraditionalQemu {
    qemu-xen-traditional = {
      src = fetchgit {
        url = "https://xenbits.xen.org/git-http/qemu-xen-traditional.git";
        # rev = "refs/tags/xen-${version}";
        # use revision hash - reproducible but must be updated with each new version
        rev = "xen-${version}";
        sha256 = "1dc6dhjp4y2irmi9yiyw1kzmm1habyy8j1s2zkf6qyak850krqj7";
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
        url = "https://xenbits.xen.org/git-http/seabios.git";
        rev = "rel-1.15.0";
        sha256 = "0gnsfmbgcvihsap8sz8c2n3qs439q44i3pwrms2nv3xcnf1sclj9";
      };
      patches = [ ./0000-qemu-seabios-enable-ATA_DMA.patch ];
      meta.description = "Xen's fork of Seabios";
    };
  } // optionalAttrs withInternalOVMF {
    "firmware/ovmf-dir-remote" = {
      src = fetchgit {
        url = "https://xenbits.xen.org/git-http/ovmf.git";
        rev = "7b4a99be8a39c12d3a7fc4b8db9f0eab4ac688d5";
        sha256 = "0zsdmdp7xqq80jd4cmw59dp7axd85lkhq8lddshlmcm5z5acfcid";
      };
      meta.description = "Xen's fork of OVMF";
    };
  } // {
    # TODO: patch Xen to make this optional?
    "firmware/etherboot/ipxe.git" = {
      src = fetchgit {
        url = "https://git.ipxe.org/ipxe.git";
        rev = "3c040ad387099483102708bb1839110bc788cefb";
        sha256 = "1cmh5grj7zyg5iiqpbsjqslniibb2730zvxsiq86bc0699j1sr6b";
      };
      meta.description = "Xen's fork of iPXE";
    };
  } // optionalAttrs withLibHVM {
    xen-libhvm-dir-remote = {
      src = fetchgit {
        name = "xen-libhvm";
        url = "https://github.com/michalpalka/xen-libhvm";
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

  NIX_CFLAGS_COMPILE = toString [
    # Fix build on Glibc 2.24.
    "-Wno-error=deprecated-declarations"
    # Fix build with GCC 8
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=stringop-truncation"
    "-Wno-error=format-truncation"
    "-Wno-error=array-bounds"
    # Fix build with GCC 9
    "-Wno-error=address-of-packed-member"
    "-Wno-error=format-overflow"
    "-Wno-error=absolute-value"
    # Fix build with GCC 10
    "-Wno-error=enum-conversion"
    "-Wno-error=zero-length-bounds"
  ];

  postPatch = ''
    # Avoid a glibc >= 2.25 deprecation warnings that get fatal via -Werror.
    #sed 1i'#include <sys/sysmacros.h>' \
    #  -i tools/blktap2/control/tap-ctl-allocate.c \
    #  -i tools/libxl/libxl_device.c
    ## Makefile didn't include previous PKG_CONFIG_PATH so glib wasn't found
    #substituteInPlace tools/Makefile \
    #  --replace 'PKG_CONFIG_PATH=$(XEN_ROOT)/tools/pkg-config' 'PKG_CONFIG_PATH=$(XEN_ROOT)/tools/pkg-config:$(PKG_CONFIG_PATH)'
  '';

  passthru = {
    qemu-system-i386 = if withInternalQemu
      then "lib/xen/bin/qemu-system-i386"
      else throw "this xen has no qemu builtin";
  };

})) ({ ocamlPackages = ocaml-ng.ocamlPackages_4_05; } // args)

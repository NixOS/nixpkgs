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
  version = "4.8.1";

  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "158kb1w61jmwxi3fc560s4269hhpxrin9xhm60ljj52njhxias8x";
  };

  # Sources needed to build tools and firmwares.
  xenfiles = optionalAttrs withInternalQemu {
    "qemu-xen" = {
      src = fetchgit {
        url = https://xenbits.xen.org/git-http/qemu-xen.git;
        rev = "refs/tags/qemu-xen-${version}";
        sha256 = "1v19pp86kcgwvsbkrdrn4rlaj02i4054avw8k70w1m0rnwgcsdbs";
      };
      buildInputs = qemuDeps;
      patches = [
        (xsaPatch {
          name = "216-qemuu";
          sha256 = "06w2iw1r5gip2bpbg19cziws965h9in0f6np74cr31f76yy30yxn";
        })
      ];
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

  patches =
    [ (xsaPatch {
        name = "213-4.8";
        sha256 = "0ia3zr6r3bqy2h48fdy7p0iz423lniy3i0qkdvzgv5a8m80darr2";
      })
      (xsaPatch {
        name = "214";
        sha256 = "0qapzx63z0yl84phnpnglpkxp6b9sy1y7cilhwjhxyigpfnm2rrk";
      })
      (xsaPatch {
        name = "217";
        sha256 = "1khs5ilif14dzcm7lmikjzkwsrfzlmir1rgrgzkc411gf18ylzmj";
      })
      (xsaPatch {
        name = "218-4.8/0001-gnttab-fix-unmap-pin-accounting-race";
        sha256 = "0r363frai239r2wmwxi48kcr50gbk5l64nja0h9lppi3z2y3dkdd";
      })
      (xsaPatch {
        name = "218-4.8/0002-gnttab-Avoid-potential-double-put-of-maptrack-entry";
        sha256 = "07wm06i7frv7bsaykakx3g9h0hfqv96zcadvwf6wv194dggq1plc";
      })
      (xsaPatch {
        name = "218-4.8/0003-gnttab-correct-maptrack-table-accesses";
        sha256 = "0ad0irc3p4dmla8sp3frxbh2qciji1dipkslh0xqvy2hyf9p80y9";
      })
      (xsaPatch {
        name = "219-4.8";
        sha256 = "16q7kiamy86x8qdvls74wmq5j72kgzgdilryig4q1b21mp0ij1jq";
      })
      (xsaPatch {
        name = "220-4.8";
        sha256 = "0214qyqx7qap5y1pdi9fm0vz4y2fbyg71gaq36fisknj35dv2mh5";
      })
      (xsaPatch {
        name = "221";
        sha256 = "1mcr1nqgxyjrkywdg7qhlfwgz7vj2if1dhic425vgd41p9cdgl26";
      })
      (xsaPatch {
        name = "222-1";
        sha256 = "0x02x4kqwfw255638fh2zcxwig1dy6kadlmqim1jgnjgmrvvqas2";
      })
      (xsaPatch {
        name = "222-2-4.8";
        sha256 = "1xhyp6q3c5l8djh965g1i8201m2wvhms8k886h4sn30hks38giin";
      })
      (xsaPatch {
        name = "224-4.8/0001-gnttab-Fix-handling-of-dev_bus_addr-during-unmap";
        sha256 = "1k326yan5811qzyvpdfkv801a19nyd09nsqayi8gyh58xx9c21m4";
      })
      (xsaPatch {
        name = "224-4.8/0002-gnttab-never-create-host-mapping-unless-asked-to";
        sha256 = "06nj1x59bbx9hrj26xmvbw8z805lfqhld9hm0ld0fs6dmcpqzcck";
      })
      (xsaPatch {
        name = "224-4.8/0003-gnttab-correct-logic-to-get-page-references-during-m";
        sha256 = "0kmag6fdsskgplcvzqp341yfi6pgc14wvjj58bp7ydb9hdk53qx2";
      })
      (xsaPatch {
        name = "224-4.8/0004-gnttab-__gnttab_unmap_common_complete-is-all-or-noth";
        sha256 = "1ww80pi7jr4gjpymkcw8qxmr5as18b2asdqv35527nqprylsff9f";
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

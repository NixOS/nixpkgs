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
        name = "206-4.5/0001-xenstored-apply-a-write-transaction-rate-limit";
        sha256 = "07vsm8mlbxh2s01ny2xywnm1bqhhxas1az31fzwb6f1g14vkzwm4";
      })
      (xsaPatch {
        name = "206-4.5/0002-xenstored-Log-when-the-write-transaction-rate-limit-";
        sha256 = "17pnvxjmhny22abwwivacfig4vfsy5bqlki07z236whc2y7yzbsx";
      })
      (xsaPatch {
        name = "206-4.5/0003-oxenstored-refactor-putting-response-on-wire";
        sha256 = "0xf566yicnisliy82cydb2s9k27l3bxc43qgmv6yr2ir3ixxlw5s";
      })
      (xsaPatch {
        name = "206-4.5/0004-oxenstored-remove-some-unused-parameters";
        sha256 = "16cqx9i0w4w3x06qqdk9rbw4z96yhm0kbc32j40spfgxl82d1zlk";
      })
      (xsaPatch {
        name = "206-4.5/0005-oxenstored-refactor-request-processing";
        sha256 = "1g2hzlv7w03sqnifbzda85mwlz3bw37rk80l248180sv3k7k6bgv";
      })
      (xsaPatch {
        name = "206-4.5/0006-oxenstored-keep-track-of-each-transaction-s-operatio";
        sha256 = "0n65yfxvpfd4cz95dpbwqj3nablyzq5g7a0klvi2y9zybhch9cmg";
      })
      (xsaPatch {
        name = "206-4.5/0007-oxenstored-move-functions-that-process-simple-operat";
        sha256 = "0qllvbc9rnj7jhhlslxxs35gvphvih0ywz52jszj4irm23ka5vnz";
      })
      (xsaPatch {
        name = "206-4.5/0008-oxenstored-replay-transaction-upon-conflict";
        sha256 = "0lixkxjfzciy9l0f980cmkr8mcsx14c289kg0mn5w1cscg0hb46g";
      })
      (xsaPatch {
        name = "206-4.5/0009-oxenstored-log-request-and-response-during-transacti";
        sha256 = "09ph8ddcx0k7rndd6hx6kszxh3fhxnvdjsq13p97n996xrpl1x7b";
      })
      (xsaPatch {
        name = "206-4.5/0010-oxenstored-allow-compilation-prior-to-OCaml-3.12.0";
        sha256 = "1y0m7sqdz89z2vs4dfr45cyvxxas323rxar0xdvvvivgkgxawvxj";
      })
      (xsaPatch {
        name = "206-4.5/0011-oxenstored-comments-explaining-some-variables";
        sha256 = "1d3n0y9syya4kaavrvqn01d3wsn85gmw7qrbylkclznqgkwdsr2p";
      })
      (xsaPatch {
        name = "206-4.5/0012-oxenstored-handling-of-domain-conflict-credit";
        sha256 = "12zgid5y9vrhhpk2syxp0x01lzzr6447fa76n6rjmzi1xgdzpaf8";
      })
      (xsaPatch {
        name = "206-4.5/0013-oxenstored-ignore-domains-with-no-conflict-credit";
        sha256 = "0v3g9pm60w6qi360hdqjcw838s0qcyywz9qpl8gzmhrg7a35avxl";
      })
      (xsaPatch {
        name = "206-4.5/0014-oxenstored-add-transaction-info-relevant-to-history-";
        sha256 = "0vv3w0h5xh554i9v2vbc8gzm8wabjf2vzya3dyv5yzvly6ygv0sb";
      })
      (xsaPatch {
        name = "206-4.5/0015-oxenstored-support-commit-history-tracking";
        sha256 = "1iv2vy29g437vj73x9p33rdcr5ln2q0kx1b3pgxq202ghbc1x1zj";
      })
      (xsaPatch {
        name = "206-4.5/0016-oxenstored-only-record-operations-with-side-effects-";
        sha256 = "1cjkw5ganbg6lq78qsg0igjqvbgph3j349faxgk1p5d6nr492zzy";
      })
      (xsaPatch {
        name = "206-4.5/0017-oxenstored-discard-old-commit-history-on-txn-end";
        sha256 = "0lm15lq77403qqwpwcqvxlzgirp6ffh301any9g401hs98f9y4ps";
      })
      (xsaPatch {
        name = "206-4.5/0018-oxenstored-track-commit-history";
        sha256 = "1jh92p6vjhkm3bn5vz260npvsjji63g2imsxflxs4f3r69sz1nkd";
      })
      (xsaPatch {
        name = "206-4.5/0019-oxenstored-blame-the-connection-that-caused-a-transa";
        sha256 = "17k264pk0fvsamj85578msgpx97mw63nmj0j9v5hbj4bgfazvj4h";
      })
      (xsaPatch {
        name = "206-4.5/0020-oxenstored-allow-self-conflicts";
        sha256 = "15z3rd49q0pa72si0s8wjsy2zvbm613d0hjswp4ikc6nzsnsh4qy";
      })
      (xsaPatch {
        name = "206-4.5/0021-oxenstored-do-not-commit-read-only-transactions";
        sha256 = "04wpzazhv90lg3228z5i6vnh1z4lzd08z0d0fvc4br6pkd0w4va8";
      })
      (xsaPatch {
        name = "206-4.5/0022-oxenstored-don-t-wake-to-issue-no-conflict-credit";
        sha256 = "1shbrn0w68rlywcc633zcgykfccck1a77igmg8ydzwjsbwxsmsjy";
      })
      (xsaPatch {
        name = "206-4.5/0023-oxenstored-transaction-conflicts-improve-logging";
        sha256 = "1086y268yh8047k1vxnxs2nhp6izp7lfmq01f1gq5n7jiy1sxcq7";
      })
      (xsaPatch {
        name = "206-4.5/0024-oxenstored-trim-history-in-the-frequent_ops-function";
        sha256 = "014zs6i4gzrimn814k5i7gz66vbb0adkzr2qyai7i4fxc9h9r7w8";
      })
      (xsaPatch {
        name = "207";
        sha256 = "0wdlhijmw9mdj6a82pyw1rwwiz605dwzjc392zr3fpb2jklrvibc";
      })
      (xsaPatch {
        name = "212";
        sha256 = "1ggjbbym5irq534a3zc86md9jg8imlpc9wx8xsadb9akgjrr1r8d";
      })
      (xsaPatch {
        name = "213-4.5";
        sha256 = "1vnqf89ydacr5bq3d6z2r33xb2sn5vsd934rncyc28ybc9rvj6wm";
      })
      (xsaPatch {
        name = "214";
        sha256 = "0qapzx63z0yl84phnpnglpkxp6b9sy1y7cilhwjhxyigpfnm2rrk";
      })
      (xsaPatch {
        name = "215";
        sha256 = "0sv8ccc5xp09f1w1gj5a9n3mlsdsh96sdb1n560vh31f4kkd61xs";
      })
      (xsaPatch {
        name = "217-4.5";
        sha256 = "067pgsfrb9py2dhm1pk9g8f6fs40vyfrcxhj8c12vzamb6svzmn4";
      })
      (xsaPatch {
        name = "218-4.5/0001-IOMMU-handle-IOMMU-mapping-and-unmapping-failures";
        sha256 = "00y6j3yjxw0igpldsavikmhlxw711k2jsj1qx0s05w2k608gadkq";
      })
      (xsaPatch {
        name = "218-4.5/0002-gnttab-fix-unmap-pin-accounting-race";
        sha256 = "0qbbfnnjlpdcd29mzmacfmi859k92c213l91q7w1rg2k6pzx928k";
      })
      (xsaPatch {
        name = "218-4.5/0003-gnttab-Avoid-potential-double-put-of-maptrack-entry";
        sha256 = "1cndzvyhf41mk4my6vh3bk9jvh2y4gpmqdhvl9zhxhmppszslqkc";
      })
      (xsaPatch {
        name = "218-4.5/0004-gnttab-correct-maptrack-table-accesses";
        sha256 = "02zpb0ffigijacqvyyjylwx3qpgibwslrka7mbxwnclf4s9c03a2";
      })
      (xsaPatch {
        name = "219-4.5";
        sha256 = "003msr5vhsc66scmdpgn0lp3p01g4zfw5vj86y5lw9ajkbaywdsm";
      })
      (xsaPatch {
        name = "220-4.5";
        sha256 = "1dj9nn6lzxlipjb3nb7b9m4337fl6yn2bd7ap1lqrjn8h9zkk1pp";
      })
      (xsaPatch {
        name = "221";
        sha256 = "1mcr1nqgxyjrkywdg7qhlfwgz7vj2if1dhic425vgd41p9cdgl26";
      })
      (xsaPatch {
        name = "222-1-4.6";
        sha256 = "1g4dqm5qx4wqlv1520jpfiscph95vllcp4gqp1rdfailk8xi0mcf";
      })
      (xsaPatch {
        name = "222-2-4.5";
        sha256 = "1hw8rhc7q4v309f4w11gxfsn5x1pirvxkg7s4kr711fnmvp9hkzd";
      })
      (xsaPatch {
        name = "224-4.5/0001-gnttab-Fix-handling-of-dev_bus_addr-during-unmap";
        sha256 = "1aislj66ss4cb3v2bh12mrqsyrf288d4h54rj94jjq7h1hnycw7h";
      })
      (xsaPatch {
        name = "224-4.5/0002-gnttab-never-create-host-mapping-unless-asked-to";
        sha256 = "1j6fgm1ccb07gg0mi5qmdr0vqwwc3n12z433g1jrija2gbk1x8aq";
      })
      (xsaPatch {
        name = "224-4.5/0003-gnttab-correct-logic-to-get-page-references-during-m";
        sha256 = "166kmicwx280fjqjvgigbmhabjksa0hhvqx5h4v6kjlcjpmxqy08";
      })
      (xsaPatch {
        name = "224-4.5/0004-gnttab-__gnttab_unmap_common_complete-is-all-or-noth";
        sha256 = "1skc0yj1zsn8xgyq1y57bdc0scvvlmd0ynrjwwf1zkias1wlilav";
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

{ callPackage, fetchurl, fetchpatch, fetchgit, ... } @ args:

let
  # Xen 4.5.5
  #
  # Patching XEN? Check the XSAs and try applying all the ones we
  # don't have yet.
  #
  # XSAs at: https://xenbits.xen.org/xsa/
  xenConfig = rec {
    version = "4.5.5";

    xsaPatch = { name , sha256 }: (fetchpatch {
      url = "https://xenbits.xen.org/xsa/xsa${name}.patch";
      inherit sha256;
    });

    name = "xen-${version}";

    src = fetchurl {
      url = "http://bits.xensource.com/oss-xen/release/${version}/${name}.tar.gz";
      sha256 = "1y74ms4yc3znf8jc3fgyq94va2y0pf7jh8m9pfqnpgklywqnw8g2";
    };

    # Sources needed to build the xen tools and tools/firmware.
    firmwareGits =
      [
        { git = { name = "seabios";
                  url = https://xenbits.xen.org/git-http/seabios.git;
                  rev = "rel-1.7.5";
                  sha256 = "0jk54ybhmw97pzyhpm6jr2x99f702kbn0ipxv5qxcbynflgdazyb";
                };
          patches = [ ./0000-qemu-seabios-enable-ATA_DMA.patch ];
        }
      ];

    toolsGits =
      [
        { git = { name = "qemu-xen";
                  url = https://xenbits.xen.org/git-http/qemu-xen.git;
                  rev = "refs/tags/qemu-xen-${version}";
                  sha256 = "014s755slmsc7xzy7qhk9i3kbjr2grxb5yznjp71dl6xxfvnday2";
                };
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
              name = "209-qemuu";
              sha256 = "05df4165by6pzxrnizkw86n2f77k9i1g4fqqpws81ycb9ng4jzin";
            })
          ];
        }
        { git = { name = "qemu-xen-traditional";
                  url = https://xenbits.xen.org/git-http/qemu-xen-traditional.git;
                  # rev = "28c21388c2a32259cff37fc578684f994dca8c9f";
                  rev = "refs/tags/xen-${version}";
                  sha256 = "0n0ycxlf1wgdjkdl8l2w1i0zzssk55dfv67x8i6b2ima01r0k93r";
                };
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
        }
        { git = { name = "xen-libhvm";
                  url = https://github.com/ts468/xen-libhvm;
                  rev = "442dcc4f6f4e374a51e4613532468bd6b48bdf63";
                  sha256 = "9ba97c39a00a54c154785716aa06691d312c99be498ebbc00dc3769968178ba8";
                };
          description = ''
            Helper library for reading ACPI and SMBIOS firmware values
            from the host system for use with the HVM guest firmware
            pass-through feature in Xen.
            '';
          #license = licenses.bsd2;
        }
      ];

      xenPatches = [ ./0001-libxl-Spice-image-compression-setting-support-for-up.patch
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
  };

in callPackage ./generic.nix (args // { xenConfig=xenConfig; })

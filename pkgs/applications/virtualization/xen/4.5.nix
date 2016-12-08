{ callPackage, fetchurl, fetchpatch, fetchgit, ... } @ args:

let
  # Xen 4.5.5
  xenConfig = rec {
    version = "4.5.5";
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
        }
        { git = { name = "qemu-xen-traditional";
                  url = https://xenbits.xen.org/git-http/qemu-xen-traditional.git;
                  # rev = "28c21388c2a32259cff37fc578684f994dca8c9f";
                  rev = "refs/tags/xen-${version}";
                  sha256 = "0n0ycxlf1wgdjkdl8l2w1i0zzssk55dfv67x8i6b2ima01r0k93r";
                };
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
                   (fetchpatch {
                     url = "https://bugzilla.redhat.com/attachment.cgi?id=1218547";
                     name = "CVE-2016-9385.patch";
                     sha256 = "0l5drg862708ngy49jl65vmv6iwxlm7h8b4vabnffc2496f2gbwk";
                   })
                   (fetchpatch {
                     url = "https://bugzilla.redhat.com/attachment.cgi?id=1218536";
                     name = "CVE-2016-9377-CVE-2016-9378-part1.patch";
                     sha256 = "1dy8xvnkdvc44ywzzlswmkljjva44c0ndw7538iicr3qyf0244n4";
                   })
                   (fetchpatch {
                     url = "https://bugzilla.redhat.com/attachment.cgi?id=1218537";
                     name = "CVE-2016-9377-CVE-2016-9378-part2.patch";
                     sha256 = "0iz36s2w6bh5h9i1a9gj1c748fq1dj90kcg2yzld1m26qx21qrr5";
                   })
                 ];
  };

in callPackage ./generic.nix (args // { xenConfig=xenConfig; })

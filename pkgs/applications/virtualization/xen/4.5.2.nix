{ callPackage, fetchurl, fetchgit, ... } @ args:

let
  # Xen 4.5.2
  xenConfig = rec {
    version = "4.5.2";
    name = "xen-${version}";

    src = fetchurl {
      url = "http://bits.xensource.com/oss-xen/release/${version}/${name}.tar.gz";
      sha256 = "1s7702zrxpsmx4vqvll4x2s762cfdiss4vgpx5s4jj7a9sn5v7jc";
    };

    # Sources needed to build the xen tools and tools/firmware.
    firmwareGits =
      [ # tag 1.7.5
        { git = { name = "seabios";
                  url = https://xenbits.xen.org/git-http/seabios.git;
                  rev = "e51488c5f8800a52ac5c8da7a31b85cca5cc95d2";
                  sha256 = "0jk54ybhmw97pzyhpm6jr2x99f702kbn0ipxv5qxcbynflgdazyb";
                };
          patches = [ ./0000-qemu-seabios-enable-ATA_DMA.patch ];
        }
        { git = { name = "ovmf";
                  url = https://xenbits.xen.org/git-http/ovmf.git;
                  rev = "cb9a7ebabcd6b8a49dc0854b2f9592d732b5afbd";
                  sha256 = "07zmdj90zjrzip74fvd4ss8n8njk6cim85s58mc6snxmqqv7gmcq";
                };
        }
      ];

    toolsGits =
      [ # tag qemu-xen-4.5.2
        { git = { name = "qemu-xen";
                  url = https://xenbits.xen.org/git-http/qemu-xen.git;
                  rev = "e5a1bb22cfb307db909dbd3404c48e5bbeb9e66d";
                  sha256 = "00h6hc1y19y9wafxk01hvwm2j8lysz26wi2dnv8md76zxavg4maa";
                };
        }
        # tag xen-4.5.2
        { git = { name = "qemu-xen-traditional";
                  url = https://xenbits.xen.org/git-http/qemu-xen-traditional.git;
                  rev = "dfe880e8d5fdc863ce6bbcdcaebaf918f8689cc0";
                  sha256 = "07jwpxgk9ls5hma6vv1frnx1aczlvpddlgiyii9qmmlxxwjs21yj";
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
                   ./0003-Add-qxl-vga-interface-support-for-upstream-qem.patch ];
  };

in callPackage ./generic.nix (args // { xenConfig=xenConfig; })

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
                  url = git://xenbits.xen.org/seabios.git;
                  rev = "e51488c5f8800a52ac5c8da7a31b85cca5cc95d2";
                  sha256 = "b96a0b9f31cab0f3993d007dcbe5f1bd69ad02b0a23eb2dc8a3ed1aafe7985cb";
                };
          patches = [ ./0000-qemu-seabios-enable-ATA_DMA.patch ];
        }
        { git = { name = "ovmf";
                  url = git://xenbits.xen.org/ovmf.git;
                  rev = "cb9a7ebabcd6b8a49dc0854b2f9592d732b5afbd";
                  sha256 = "1ncb8dpqzaj3s8am44jvclhby40hwczljz0a1gd282h9yr4k4sk2";
                };
        }
      ];

    toolsGits =
      [ # tag qemu-xen-4.5.2
        { git = { name = "qemu-xen";
                  url = git://xenbits.xen.org/qemu-upstream-4.5-testing.git;
                  rev = "e5a1bb22cfb307db909dbd3404c48e5bbeb9e66d";
                  sha256 = "1qflb3j8qcvipavybqhi0ql7m2bx51lhzgmf7pdbls8minpvdzg2";
                };
        }
        # tag xen-4.5.2
        { git = { name = "qemu-xen-traditional";
                  url = git://xenbits.xen.org/qemu-xen-4.5-testing.git;
                  rev = "dfe880e8d5fdc863ce6bbcdcaebaf918f8689cc0";
                  sha256 = "14fxdsnkq729z5glkifdpz26idmn7fl38w1v97xj8cf6ifvk76cz";
                };
        }
        { git = { name = "xen-libhvm";
                  url = "https://github.com/ts468/xen-libhvm";
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

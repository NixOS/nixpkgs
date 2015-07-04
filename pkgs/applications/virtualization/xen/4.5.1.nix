{ callPackage, fetchurl, fetchgit, ... } @ args:

let
  # Xen 4.5.1
  xenConfig = {
    name = "xen-4.5.1";
    version = "4.5.1";

    src = fetchurl {
      url = "http://bits.xensource.com/oss-xen/release/4.5.1/xen-4.5.1.tar.gz";
      sha256 = "0w8kbqy7zixacrpbk3yj51xx7b3f6l8ghsg3551w8ym6zka13336";
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
                  rev = "447d264115c476142f884af0be287622cd244423";
                  sha256 = "7086f882495a8be1497d881074e8f1005dc283a5e1686aec06c1913c76a6319b";
                };
        }
      ];

    toolsGits =
      [ # tag qemu-xen-4.5.1
        { git = { name = "qemu-xen";
                  url = git://xenbits.xen.org/qemu-upstream-4.5-testing.git;
                  rev = "d9552b0af21c27535cd3c8549bb31d26bbecd506";
                  sha256 = "15dbz8j26wl4vs5jijhccwgd8c6wkmpj4mz899fa7i1bbh8yysfy";
                };
        }
        # tag xen-4.5.1
        { git = { name = "qemu-xen-traditional";
                  url = git://xenbits.xen.org/qemu-xen-4.5-testing.git;
                  rev = "afaa35b4bc975b2b89ad44c481d0d7623e3d1c49";
                  sha256 = "906b31cf32b52d29e521abaa76d641123bdf24f33fa53c6f109b6d7834e514be";
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


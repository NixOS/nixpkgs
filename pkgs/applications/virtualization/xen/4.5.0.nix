{ callPackage, fetchurl, fetchgit, ... } @ args:

let
  # Xen 4.5.0
  xenConfig = {
    name = "xen-4.5.0";
    version = "4.5.0";

    src = fetchurl {
      url = "http://bits.xensource.com/oss-xen/release/4.5.0/xen-4.5.0.tar.gz";
      sha256 = "0fvg00d596gh6cfm51xr8kj2mghcyivrf6np3dafnbldnbi41nsv";
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
      [ # tag qemu-xen-4.5.0
        { git = { name = "qemu-xen";
                  url = git://xenbits.xen.org/qemu-upstream-4.5-testing.git;
                  rev = "1ebb75b1fee779621b63e84fefa7b07354c43a99";
                  sha256 = "1j312q2mqvkvby9adkkxf7f1pn3nz85g5mr9nbg4qpf2y9cg122z";
                };
        }
        # tag xen-4.5.0
        { git = { name = "qemu-xen-traditional";
                  url = git://xenbits.xen.org/qemu-xen-4.5-testing.git;
                  rev = "b0d42741f8e9a00854c3b3faca1da84bfc69bf22";
                  sha256 = "ce52b5108936c30ab85ec0c9554f88d5e7b34896f3acb666d56765b49c86f2af";
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

    xenserverPatches =
      let
        patches = {
          url = https://github.com/ts468/xen-4.5.pg.git;
          rev = "3442b65b490f43c817cbc53369220d0b1ab9b785";
          sha256 = "31436c15def0a300b3ea1a63b2208c4a3bcbb143db5c6488d4db370b3ceeb845";
        };
      in ''
        cp -r ${fetchgit patches}/master patches
        quilt push -a
        substituteInPlace tools/xenguest/Makefile --replace "_BSD_SOURCE" "_DEFAULT_SOURCE"
      '';

    xenPatches = [ ./0001-libxl-Spice-image-compression-setting-support-for-up.patch
                   ./0002-libxl-Spice-streaming-video-setting-support-for-upst.patch
                   ./0003-Add-qxl-vga-interface-support-for-upstream-qem.patch ];
  };

in callPackage ./generic.nix (args // { xenConfig=xenConfig; })


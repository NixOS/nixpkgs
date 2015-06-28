{ callPackage, fetchurl, ... } @ args:

let
  # Xen 4.4.1
  xenConfig = {
    name = "xen-4.4.1";
    version = "4.4.1";

    src = fetchurl {
      url = "http://bits.xensource.com/oss-xen/release/4.4.1/xen-4.4.1.tar.gz";
      sha256 = "09gaqydqmy64s5pqnwgjyzhd3wc61xyghpqjfl97kmvm8ly9vd2m";
    };

    # Sources needed to build the xen tools and tools/firmware.
    toolsGits =
      [ # tag qemu-xen-4.4.1
        { name = "qemu-xen";
          url = git://xenbits.xen.org/qemu-upstream-4.4-testing.git;
          rev = "65fc9b78ba3d868a26952db0d8e51cecf01d47b4";
          sha256 = "e24fb58f773fd9134c5aae6d3ca7e9f754dc9822de92b1eb2cedc76faf911f18";
        }
        # tag xen-4.4.1
        {  name = "qemu-xen-traditional";
          url = git://xenbits.xen.org/qemu-xen-4.4-testing.git;
          rev = "6ae4e588081620b141071eb010ec40aca7e12876";
          sha256 = "b1ed1feb92fbe658273a8d6d38d6ea60b79c1658413dd93979d6d128d8554ded";
        }
      ];

    firmwareGits =
      [ # tag 1.7.3.1
        { name = "seabios";
          url = git://xenbits.xen.org/seabios.git;
          rev = "7d9cbe613694924921ed1a6f8947d711c5832eee";
          sha256 = "c071282bbcb1dd0d98536ef90cd1410f5d8da19648138e0e3863bc540d954a87";
        }
        { name = "ovmf";
          url = git://xenbits.xen.org/ovmf.git;
          rev = "447d264115c476142f884af0be287622cd244423";
          sha256 = "7086f882495a8be1497d881074e8f1005dc283a5e1686aec06c1913c76a6319b";
        }
      ];

  };

in callPackage ./generic.nix (args // { xenConfig=xenConfig; })

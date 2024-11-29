{ fetchurl }:
rec {
  version = "1.8.13";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-eRABcMokkLEpXZuLEwWPMOI9eruJe/GgcXVddnB4vdE=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-1PPUL05XZkfbIV2rc8Nl0gQ9MmrT0hqA+MRzGdPkP+U=";
    })
  ];
}

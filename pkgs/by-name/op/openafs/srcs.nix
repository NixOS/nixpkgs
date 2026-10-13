{ fetchurl }:
rec {
  version = "1.8.16.1";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-z1kGdYmilUcePxD2RPDyFlETNHzIsK0Pu0EjJZoq8KI=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-kZhKpuF1VEZC4d2z10ROwibq57oTTTfAXfEPu4CNnjA=";
    })
  ];
}

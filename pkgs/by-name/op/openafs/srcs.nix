{ fetchurl }:
rec {
  version = "1.8.15";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-MvEN0kG12LhG5CWrnL8nW1VroYgL9998RZzZ60kFg1U=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-kAGRw3T0VdJ/XMqqFjV0Z7gzKbWeyZWEsMsBJ+7ijsE=";
    })
  ];
}

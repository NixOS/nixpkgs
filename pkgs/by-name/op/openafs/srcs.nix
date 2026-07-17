{ fetchurl }:
rec {
  version = "1.8.16";
  src = fetchurl {
    url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    hash = "sha256-7oEnaJdXy9lyOoU6EvrigcnenD6JSkvZAQf7b4UnBGk=";
  };

  srcs = [
    src
    (fetchurl {
      url = "https://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      hash = "sha256-F9fyLe5Ofs6Ri4MXlO63wOZmhZuY8FAh2P/aoAX5wiQ=";
    })
  ];
}

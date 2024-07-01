{ lib
, stdenvNoCC
, fetchurl
, writeScript
}:
stdenvNoCC.mkDerivation rec {
  pname = "metaphlan-db";
  version = "Jun23_CHOCOPhlAnSGB_202307";

  dontUnpack = true;

  # The server only supports HTTP for some reason. Otherwise, obviously I'd use HTTPS.
  # This isn't vulnerable to MitM attacks, though, because the hash is checked.
  srcs = [
    (fetchurl {
      url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}.tar";
      hash = "sha256-MPQuPGg2yeWr/X8OfWM1euVJg2zQEP70V6aKVKoqMJc=";
    })
    (fetchurl {
      url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}.md5";
      hash = "sha256-IDAFLTF/Vgqdk8oqgQuQbqFWs8vVT8SJpXl5io5FT/8=";
    })
    (fetchurl {
      url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}_marker_info.txt.bz2";
      hash = "sha256-DiYRKR7lCSN5WmzeCKizSle9jERAgQpwINfHvApsw2M=";
    })
    (fetchurl {
      url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}_species.txt.bz2";
      hash = "sha256-gL5a/jqgjtS6a1JNa1Y5u+idlnSz3UFoaYVjyQLJhW4=";
    })
    (fetchurl {
      url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/bowtie2_indexes/mpa_v${version}_bt2.tar";
      hash = "sha256-xSmxvH9WD653SK6DN+8eOpIbf70IhwNaG+A7IYD51DA=";
    })
    (fetchurl {
      url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/bowtie2_indexes/mpa_v${version}_bt2.md5";
      hash = "sha256-w/w03ahaQ8YSrU0O/L9LcyXzrXGYpn4B6vfZ+1e08uU=";
    })
  ];

  installPhase = ''
    mkdir -p $out

    echo "mpa_v${version}" > $out/mpa_latest

    cp ${builtins.elemAt srcs 0} $out/mpa_v${version}.tar
    cp ${builtins.elemAt srcs 1} $out/mpa_v${version}.md5
    cp ${builtins.elemAt srcs 2} $out/mpa_v${version}_marker_info.txt.bz2
    cp ${builtins.elemAt srcs 3} $out/mpa_v${version}_species.txt.bz2
    cp ${builtins.elemAt srcs 4} $out/mpa_v${version}_bt2.tar
    cp ${builtins.elemAt srcs 5} $out/mpa_v${version}_bt2.md5

    tar -xf $out/mpa_v${version}.tar -C $out
    tar -xf $out/mpa_v${version}_bt2.tar -C $out
    bzip2 -kd $out/mpa_v${version}_marker_info.txt.bz2
    bzip2 -kd $out/mpa_v${version}_species.txt.bz2
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Database files for MetaPhlAn";
    homepage = "https://github.com/biobakery/MetaPhlAn";
    license = licenses.free; # These are raw data files not covered under copyright law
    maintainers = with maintainers; [ pandapip1 ];
    platforms = platforms.all;
    hydraPlatforms = []; # Exceeds Hydra's maximum build size
  };
}

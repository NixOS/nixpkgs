{
  lib,
  runCommand,
  fetchurl,
}:

let
  version = "Jun23_CHOCOPhlAnSGB_202307";

  # The server only supports HTTP for some reason. Otherwise, obviously I'd use HTTPS.
  # This isn't vulnerable to MitM attacks, though, because the hash is checked.
  mpa_database = fetchurl {
    name = "mpa_v${version}.tar";
    url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}.tar";
    hash = "sha256-MPQuPGg2yeWr/X8OfWM1euVJg2zQEP70V6aKVKoqMJc=";
  };
  mpa_checksum = fetchurl {
    name = "mpa_v${version}.md5";
    url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}.md5";
    hash = "sha256-IDAFLTF/Vgqdk8oqgQuQbqFWs8vVT8SJpXl5io5FT/8=";
  };
  mpa_marker_info = fetchurl {
    name = "mpa_v${version}_marker_info.txt.bz2";
    url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}_marker_info.txt.bz2";
    hash = "sha256-DiYRKR7lCSN5WmzeCKizSle9jERAgQpwINfHvApsw2M=";
  };
  mpa_species = fetchurl {
    name = "mpa_v${version}_species.txt.bz2";
    url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_v${version}_species.txt.bz2";
    hash = "sha256-gL5a/jqgjtS6a1JNa1Y5u+idlnSz3UFoaYVjyQLJhW4=";
  };
  mpa_bowtie_db = fetchurl {
    name = "mpa_v${version}_bt2.tar";
    url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/bowtie2_indexes/mpa_v${version}_bt2.tar";
    hash = "sha256-xSmxvH9WD653SK6DN+8eOpIbf70IhwNaG+A7IYD51DA=";
  };
  mpa_bowtie_checksum = fetchurl {
    name = "mpa_v${version}_bt2.md5";
    url = "http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/bowtie2_indexes/mpa_v${version}_bt2.md5";
    hash = "sha256-w/w03ahaQ8YSrU0O/L9LcyXzrXGYpn4B6vfZ+1e08uU=";
  };
in
runCommand "metaphlan-db"
  {
    version = "0-${version}";

    meta = {
      description = "Database files for MetaPhlAn";
      homepage = "https://github.com/biobakery/MetaPhlAn";
      license = lib.licenses.free; # These are raw data files not covered under copyright law
      maintainers = with lib.maintainers; [ pandapip1 ];
      platforms = lib.platforms.all;
      hydraPlatforms = [ ]; # Exceeds Hydra's maximum build size
    };
  }
  ''
    mkdir -p $out

    echo "mpa_v${version}" > $out/mpa_latest

    ln -s ${mpa_database} $out/mpa_v${version}.tar
    ln -s ${mpa_checksum} $out/mpa_v${version}.md5
    ln -s ${mpa_marker_info} $out/mpa_v${version}_marker_info.txt.bz2
    ln -s ${mpa_species} $out/mpa_v${version}_species.txt.bz2
    ln -s ${mpa_bowtie_db} $out/mpa_v${version}_bt2.tar
    ln -s ${mpa_bowtie_checksum} $out/mpa_v${version}_bt2.md5

    tar -xf ${mpa_database} -C $out
    tar -xf ${mpa_bowtie_db} -C $out

    bunzip2 -c ${mpa_marker_info} > $out/mpa_v${version}_marker_info.txt
    bunzip2 -c ${mpa_species} > $out/mpa_v${version}_species.txt
  ''

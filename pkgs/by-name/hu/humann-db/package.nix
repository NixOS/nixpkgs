{
  lib,
  runCommand,
  fetchzip,
}:

let
  db_version = "201901b";
in
runCommand "humann-db"
  (rec {
    version = "0-${db_version}";

    nucleotide = fetchzip {
      name = "full_chocophlan.v296_${db_version}";
      url = "http://huttenhower.sph.harvard.edu/humann_data/chocophlan/full_chocophlan.v296_${db_version}.tar.gz";
      stripRoot = false;
      hash = "sha256-+wMnQowBlQ3PNAHFNa1Z27cvHOGZrh1p6032IuWEanQ=";
    };

    protein = fetchzip {
      name = "uniref90_annotated_v${db_version}_full";
      url = "http://huttenhower.sph.harvard.edu/humann_data/uniprot/uniref_annotated/uniref90_annotated_v${db_version}_full.tar.gz";
      stripRoot = false;
      hash = "sha256-69ENV/Ff0NojKaaVr7n7OYuRzaGWAr+VCDpSKezY8XA=";
    };

    utilityMapping = fetchzip {
      name = "full_mapping_v${db_version}";
      url = "http://huttenhower.sph.harvard.edu/humann_data/full_mapping_v${db_version}.tar.gz";
      stripRoot = false;
      hash = "sha256-0IvLEe6CPGn0IVG//lJbuozD/K2LRxWnEAvCYxPtt7o=";
    };

    meta = {
      description = "Database files for Humann";
      homepage = "https://github.com/biobakery/humann";
      license = lib.licenses.free; # These are raw data files not covered under copyright law
      maintainers = with lib.maintainers; [ pandapip1 ];
      platforms = lib.platforms.all;
      hydraPlatforms = [ ]; # Exceeds Hydra's maximum build size
    };
  })
  ''
    mkdir -p $out

    ln -s $nucleotide $out/nucleotide_database
    ln -s $protein $out/protein_database
    ln -s $utilityMapping $out/utility_mapping
  ''

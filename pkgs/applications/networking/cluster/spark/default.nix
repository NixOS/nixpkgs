{ lib
, stdenv
, fetchzip
, makeWrapper
, jdk8
, python3
, python310
, coreutils
, hadoop
, RSupport ? true
, R
, nixosTests
}:

let
  spark = { pname, version, hash, extraMeta ? {}, pysparkPython ? python3 }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version hash hadoop R pysparkPython;
      inherit (finalAttrs.hadoop) jdk;
      src = fetchzip {
        url = with finalAttrs; "mirror://apache/spark/${pname}-${version}/${pname}-${version}-bin-without-hadoop.tgz";
        inherit (finalAttrs) hash;
      };
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ finalAttrs.jdk finalAttrs.pysparkPython ]
        ++ lib.optional RSupport R;

      installPhase = with finalAttrs; ''
        mkdir -p "$out/opt"
        mv * $out/
        for n in $(find $out/bin -type f -executable ! -name "find-spark-home"); do
          wrapProgram "$n" --set JAVA_HOME "${jdk}" \
            --run "[ -z SPARK_DIST_CLASSPATH ] && export SPARK_DIST_CLASSPATH=$(${finalAttrs.hadoop}/bin/hadoop classpath)" \
            ${lib.optionalString RSupport ''--set SPARKR_R_SHELL "${R}/bin/R"''} \
            --prefix PATH : "${
              lib.makeBinPath (
                [ pysparkPython ] ++
                (lib.optionals RSupport [ R ])
              )}"
        done
        ln -s ${finalAttrs.hadoop} "$out/opt/hadoop"
        ${lib.optionalString RSupport ''ln -s ${finalAttrs.R} "$out/opt/R"''}
      '';

      passthru = {
        tests = nixosTests.spark.default.passthru.override {
          sparkPackage = finalAttrs.finalPackage;
        };
        # Add python packages to PYSPARK_PYTHON
        withPythonPackages = f: finalAttrs.finalPackage.overrideAttrs (old: {
          pysparkPython = old.pysparkPython.withPackages f;
        });
      };

      meta = {
        description = "Apache Spark is a fast and general engine for large-scale data processing";
        homepage = "https://spark.apache.org/";
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
        license = lib.licenses.asl20;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ thoughtpolice offline kamilchm illustris ];
      } // extraMeta;
    });
in
{
  spark_3_5 = spark rec {
    pname = "spark";
    version = "3.5.0";
    hash = "sha256-f+a4a23aOM0GCDoZlZ7WNXs0Olzyh3yMtO8ZmEoYvZ4=";
  };
  spark_3_4 = spark rec {
    pname = "spark";
    version = "3.4.1";
    hash = "sha256-4vC9oBCycVNy3hIxFII65j7FHlrxhDURU3NmsJZPDDU=";
  };
  spark_3_3 = spark rec {
    pname = "spark";
    version = "3.3.3";
    hash = "sha256-YtHxRYTwrwSle3UpFjRSwKcnLFj2m9/zLBENH/HVzuM=";
    pysparkPython = python310;
  };
  spark_3_2 = spark rec {
    pname = "spark";
    version = "3.2.4";
    hash = "sha256-xL4W+dTWbvmmncq3/8iXmhp24rp5SftvoRfkTyxCI8E=";
    pysparkPython = python310;
    extraMeta.knownVulnerabilities = [ "CVE-2023-22946" ];
  };
}

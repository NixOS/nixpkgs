{ lib
, stdenv
, fetchzip
, makeWrapper
, jdk8
, python3
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
      buildInputs = with finalAttrs; [ jdk pysparkPython ]
        ++ lib.optional RSupport finalAttrs.R;

      installPhase = ''
        mkdir -p "$out/opt"
        mv * $out/
        for n in $(find $out/bin -type f -executable ! -name "find-spark-home"); do
          wrapProgram "$n" --set JAVA_HOME "${finalAttrs.jdk}" \
            --run "[ -z $SPARK_DIST_CLASSPATH ] && export SPARK_DIST_CLASSPATH=$(${finalAttrs.hadoop}/bin/hadoop classpath)" \
            ${lib.optionalString RSupport ''--set SPARKR_R_SHELL "${finalAttrs.R}/bin/R"''} \
            --prefix PATH : "${
              lib.makeBinPath (
                [ finalAttrs.pysparkPython ] ++
                (lib.optionals RSupport [ finalAttrs.R ])
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
    version = "3.4.2";
    hash = "sha256-qr0tRuzzEcarJznrQYkaQzGqI7tugp/XJpoZxL7tJwk=";
  };
}

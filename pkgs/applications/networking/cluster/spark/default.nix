{ lib
, stdenv
, fetchzip
, makeWrapper
, jdk8
, python3Packages
, extraPythonPackages ? [ ]
, coreutils
, hadoopSupport ? true
, hadoop
, RSupport ? true
, R
}:

let
  spark = { pname, version, hash, extraMeta ? {} }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version hash;
      jdk = if hadoopSupport then hadoop.jdk else jdk8;
      src = fetchzip {
        url = with finalAttrs; "mirror://apache/spark/${pname}-${version}/${pname}-${version}-bin-without-hadoop.tgz";
        inherit (finalAttrs) hash;
      };
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ finalAttrs.jdk python3Packages.python ]
        ++ extraPythonPackages
        ++ lib.optional RSupport R;

      untarDir = with finalAttrs; "${pname}-${version}";
      installPhase = with finalAttrs; ''
        mkdir -p $out/{lib/${untarDir}/conf,bin,/share/java}
        mv * $out/lib/${untarDir}

        cp $out/lib/${untarDir}/conf/log4j.properties{.template,} || \
          cp $out/lib/${untarDir}/conf/log4j2.properties{.template,}

        cat > $out/lib/${untarDir}/conf/spark-env.sh <<- EOF
        export JAVA_HOME="${jdk}"
        export SPARK_HOME="$out/lib/${untarDir}"
      '' + lib.optionalString hadoopSupport ''
        export SPARK_DIST_CLASSPATH=$(${hadoop}/bin/hadoop classpath)
      '' + ''
        export PYSPARK_PYTHON="${python3Packages.python}/bin/${python3Packages.python.executable}"
        export PYTHONPATH="\$PYTHONPATH:$PYTHONPATH"
        ${lib.optionalString RSupport ''
          export SPARKR_R_SHELL="${R}/bin/R"
          export PATH="\$PATH:${R}/bin"''}
        EOF

        for n in $(find $out/lib/${untarDir}/bin -type f ! -name "*.*"); do
          makeWrapper "$n" "$out/bin/$(basename $n)"
          substituteInPlace "$n" --replace dirname ${coreutils.out}/bin/dirname
        done
        for n in $(find $out/lib/${untarDir}/sbin -type f); do
          # Spark deprecated scripts with "slave" in the name.
          # This line adds forward compatibility with the nixos spark module for
          # older versions of spark that don't have the new "worker" scripts.
          ln -s "$n" $(echo "$n" | sed -r 's/slave(s?).sh$/worker\1.sh/g') || true
        done
        ln -s $out/lib/${untarDir}/lib/spark-assembly-*.jar $out/share/java
      '';

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
  };
  spark_3_2 = spark rec {
    pname = "spark";
    version = "3.2.4";
    hash = "sha256-xL4W+dTWbvmmncq3/8iXmhp24rp5SftvoRfkTyxCI8E=";
    extraMeta.knownVulnerabilities = [ "CVE-2023-22946" ];
  };
}

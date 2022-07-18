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

with lib;

let
  spark = { pname, version, sha256, extraMeta ? {} }:
    stdenv.mkDerivation rec {
      inherit pname version;
      jdk = if hadoopSupport then hadoop.jdk else jdk8;
      src = fetchzip {
        url = "mirror://apache/spark/${pname}-${version}/${pname}-${version}-bin-without-hadoop.tgz";
        sha256 = sha256;
      };
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ jdk python3Packages.python ]
        ++ extraPythonPackages
        ++ optional RSupport R;

      untarDir = "${pname}-${version}";
      installPhase = ''
        mkdir -p $out/{lib/${untarDir}/conf,bin,/share/java}
        mv * $out/lib/${untarDir}

        cp $out/lib/${untarDir}/conf/log4j.properties{.template,}

        cat > $out/lib/${untarDir}/conf/spark-env.sh <<- EOF
        export JAVA_HOME="${jdk}"
        export SPARK_HOME="$out/lib/${untarDir}"
      '' + optionalString hadoopSupport ''
        export SPARK_DIST_CLASSPATH=$(${hadoop}/bin/hadoop classpath)
      '' + ''
        export PYSPARK_PYTHON="${python3Packages.python}/bin/${python3Packages.python.executable}"
        export PYTHONPATH="\$PYTHONPATH:$PYTHONPATH"
        ${optionalString RSupport ''
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
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = lib.licenses.asl20;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ thoughtpolice offline kamilchm illustris ];
      } // extraMeta;
    };
in
{
  spark_3_2 = spark rec {
    pname = "spark";
    version = "3.2.1";
    sha256 = "0kxdqczwmj6pray0h8h1qhygni9m82jzznw5fbv9hrxrkq1v182d";
  };
  spark_3_1 = spark rec {
    pname = "spark";
    version = "3.1.3";
    sha256 = "sha256-RIQyN5YjxFLfNIrETR3Vv99zsHxt77rhOXHIThCI2Y8=";
  };
  spark_2_4 = spark rec {
    pname = "spark";
    version = "2.4.8";
    sha256 = "1mkyq0gz9fiav25vr0dba5ivp0wh0mh7kswwnx8pvsmb6wbwyfxv";
    extraMeta.knownVulnerabilities = [ "CVE-2021-38296" ];
  };
}

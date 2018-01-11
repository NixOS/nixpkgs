{ stdenv, fetchzip, makeWrapper, jre, pythonPackages
, RSupport? true, R
, mesosSupport ? true, mesos
, version
}:

let
  versionMap = {
    "1.6.3" = {
                hadoopVersion = "cdh4";
                sparkSha256 = "00il083cjb9xqzsma2ifphq9ggichwndrj6skh2z5z9jk3z0lgyn";
              };
    "2.1.2" = {
                hadoopVersion = "hadoop2.4";
                sparkSha256 = "0ri272bbpdbhj68ynp1d769zp5rhpjc7hh1zi8gfp0lj31h6vpza";
              };
  };
in

with versionMap.${version};

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "spark-${version}";

  src = fetchzip {
    url    = "mirror://apache/spark/${name}/${name}-bin-${hadoopVersion}.tgz";
    sha256 = sparkSha256;
  };

  buildInputs = [ makeWrapper jre pythonPackages.python pythonPackages.numpy ]
    ++ optional RSupport R
    ++ optional mesosSupport mesos;

  untarDir = "${name}-bin-${hadoopVersion}";
  installPhase = ''
    mkdir -p $out/{lib/${untarDir}/conf,bin,/share/java}
    mv * $out/lib/${untarDir}

    sed -e 's/INFO, console/WARN, console/' < \
       $out/lib/${untarDir}/conf/log4j.properties.template > \
       $out/lib/${untarDir}/conf/log4j.properties

    cat > $out/lib/${untarDir}/conf/spark-env.sh <<- EOF
    export JAVA_HOME="${jre}"
    export SPARK_HOME="$out/lib/${untarDir}"
    export PYSPARK_PYTHON="${pythonPackages.python}/bin/${pythonPackages.python.executable}"
    export PYTHONPATH="\$PYTHONPATH:$PYTHONPATH"
    ${optionalString RSupport
      ''export SPARKR_R_SHELL="${R}/bin/R"
        export PATH=$PATH:"${R}/bin/R"''}
    ${optionalString mesosSupport
      ''export MESOS_NATIVE_LIBRARY="$MESOS_NATIVE_LIBRARY"''}
    EOF

    for n in $(find $out/lib/${untarDir}/bin -type f ! -name "*.*"); do
      makeWrapper "$n" "$out/bin/$(basename $n)"
    done
    ln -s $out/lib/${untarDir}/lib/spark-assembly-*.jar $out/share/java
  '';

  meta = {
    description      = "Apache Spark is a fast and general engine for large-scale data processing";
    homepage         = "http://spark.apache.org";
    license          = stdenv.lib.licenses.asl20;
    platforms        = stdenv.lib.platforms.all;
    maintainers      = with maintainers; [ thoughtpolice offline ];
    knownVulnerabilities = optional (!((versionAtLeast version "2.2.0") || (versionOlder version "2.2.0" && versionAtLeast version "2.1.2"))) "CVE-2017-12612";
    repositories.git = git://git.apache.org/spark.git;
  };
}

{ stdenv, fetchzip, makeWrapper, jre, pythonPackages
, mesosSupport ? true, mesos
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name    = "spark-${version}";
  version = "1.6.2";

  src = fetchzip {
    url    = "mirror://apache/spark/${name}/${name}-bin-cdh4.tgz";
    sha256 = "1wiwfz68npsznq63xyxghhn161ynhvyjwnspbr8cl7n101vm7ic7";
  };

  buildInputs = [ makeWrapper jre pythonPackages.python pythonPackages.numpy ]
  # remove mesos dependency temporarily as it is broken atm
  # ++ optional mesosSupport mesos
  ;

  untarDir = "${name}-bin-cdh4";
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
    ${optionalString mesosSupport
      ''export MESOS_NATIVE_LIBRARY="$MESOS_NATIVE_LIBRARY"''}
    EOF

    for n in $(find $out/lib/${untarDir}/bin -type f ! -name "*.*"); do
      makeWrapper "$n" "$out/bin/$(basename $n)"
    done
    ln -s $out/lib/${untarDir}/lib/spark-assembly-*.jar $out/share/java
  '';

  meta = {
    description      = "A fast and general engine for large-scale data processing. ";
    homepage         = "http://spark.apache.org";
    license          = stdenv.lib.licenses.asl20;
    platforms        = stdenv.lib.platforms.all;
    maintainers      = with maintainers; [ thoughtpolice offline ];
    repositories.git = git://git.apache.org/spark.git;
  };
}

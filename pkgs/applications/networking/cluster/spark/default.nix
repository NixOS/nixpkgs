{ stdenv, fetchzip, makeWrapper, jre, pythonPackages, coreutils, hadoop
, RSupport? true, R
, mesosSupport ? true, mesos
, version
}:

let
  sha256 = {
    "1.6.3" = "142hw73wf20d846l83ydx0yg7qj5qxywm4h7qrhwnd7lsy2sbnjf";
    "2.4.3" = "1dvvr1q3dz961bl7qigxngrp4ssrbll3g1s6nkra6gyr83pis96c"; 
  }.${version};
in

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "spark";
  inherit version;

  src = fetchzip {
    inherit sha256;
    url    = "mirror://apache/spark/${pname}-${version}/${pname}-${version}-bin-without-hadoop.tgz";
  };

  buildInputs = [ makeWrapper jre pythonPackages.python pythonPackages.numpy ]
    ++ optional RSupport R
    ++ optional mesosSupport mesos;

  untarDir = "${pname}-${version}-bin-without-hadoop";
  installPhase = ''
    mkdir -p $out/{lib/${untarDir}/conf,bin,/share/java}
    mv * $out/lib/${untarDir}

    sed -e 's/INFO, console/WARN, console/' < \
       $out/lib/${untarDir}/conf/log4j.properties.template > \
       $out/lib/${untarDir}/conf/log4j.properties

    cat > $out/lib/${untarDir}/conf/spark-env.sh <<- EOF
    export JAVA_HOME="${jre}"
    export SPARK_HOME="$out/lib/${untarDir}"
    export SPARK_DIST_CLASSPATH=$(${hadoop}/bin/hadoop classpath)
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
      substituteInPlace "$n" --replace dirname ${coreutils.out}/bin/dirname
    done
    ln -s $out/lib/${untarDir}/lib/spark-assembly-*.jar $out/share/java
  '';

  meta = {
    description      = "Apache Spark is a fast and general engine for large-scale data processing";
    homepage         = "http://spark.apache.org";
    license          = stdenv.lib.licenses.asl20;
    platforms        = stdenv.lib.platforms.all;
    maintainers      = with maintainers; [ thoughtpolice offline kamilchm ];
    repositories.git = git://git.apache.org/spark.git;
  };
}

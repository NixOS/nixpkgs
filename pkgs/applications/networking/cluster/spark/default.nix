{ stdenv, fetchurl, jre, bash, simpleBuildTool, python27Packages }:

stdenv.mkDerivation rec {
  name    = "spark-${version}";
  version = "0.9.0";

  src = fetchurl {
    url    = "http://d3kbcqa49mib13.cloudfront.net/${name}-incubating-bin-cdh4.tgz";
    sha256 = "0dgirq2ws25accijijanqij6d1mwxkrcqkmq1xsslfpz26svs1w1";
  };

  unpackPhase = ''tar zxf $src'';

  untarDir = "spark-${version}-incubating-bin-cdh4";
  installPhase = ''
    set -x
    mkdir -p $out/lib $out/bin
    mv ${untarDir} $out/lib

    cat > $out/bin/spark-class <<EOF
    #!${bash}/bin/bash
    export JAVA_HOME=${jre}
    export SPARK_HOME=$out/lib/${untarDir}

    if [ -z "\$1" ]; then
      echo "Usage: spark-class <class> [<args>]" >&2
      exit 1
    fi

    export SPARK_MEM=\''${SPARK_MEM:-1024m}

    JAVA_OPTS=""
    JAVA_OPTS="\$JAVA_OPTS -Djava.library.path=\"\$SPARK_LIBRARY_PATH\""
    JAVA_OPTS="\$JAVA_OPTS -Xms\$SPARK_MEM -Xmx\$SPARK_MEM"
    export JAVA_OPTS

    CLASSPATH=\`$out/lib/${untarDir}/bin/compute-classpath.sh\`
    export CLASSPATH

    exec ${jre}/bin/java -cp "\$CLASSPATH" \$JAVA_OPTS "\$@"
    EOF
    chmod +x $out/bin/spark-class

    cat > $out/bin/spark-shell <<EOF
    #!${bash}/bin/bash
    set -o posix
    export JAVA_HOME=${jre}
    export SPARK_HOME=$out/lib/${untarDir}
    for o in "\$@"; do
      if [ "\$1" = "-c" -o "\$1" = "--cores" ]; then
        shift
        if [ -n "\$1" ]; then
          OPTIONS="-Dspark.cores.max=\$1"
          shift
        fi
      fi
    done

    exit_status=127
    saved_stty=""

    function restoreSttySettings() {
      stty \$saved_stty
      saved_stty=""
    }

    function onExit() {
      if [[ "\$saved_stty" != "" ]]; then
        restoreSttySettings
      fi
      exit \$exit_status
    }

    trap onExit INT

    saved_stty=\$(stty -g 2>/dev/null)
    if [[ ! \$? ]]; then
      saved_stty=""
    fi

    $out/bin/spark-class \$OPTIONS org.apache.spark.repl.Main "\$@"

    exit_status=\$?
    onExit
    EOF
    chmod +x $out/bin/spark-shell

    cat > $out/bin/pyspark <<EOF
    #!${bash}/bin/bash
    export JAVA_HOME=${jre}
    export SPARK_HOME=$out/lib/${untarDir}
    export PYTHONPATH=$out/lib/${untarDir}/python:\$PYTHONPATH
    export OLD_PYTHONSTARTUP=\$PYTHONSTARTUP
    export PYTHONSTARTUP=$out/lib/${untarDir}/python/pyspark/shell.py
    export SPARK_MEM=\''${SPARK_MEM:-1024m}
    exec ${python27Packages.ipythonLight}/bin/ipython \$@
    EOF
    chmod +x $out/bin/pyspark

    cat > $out/bin/spark-upload-scala <<EOF
    #!${bash}/bin/bash
    export JAVA_HOME=${jre}
    export SPARK_HOME=$out/lib/${untarDir}
    export SPARK_MEM=\''${SPARK_MEM:-1024m}

    CLASS=\$1; shift
    exec ${simpleBuildTool}/bin/sbt package "run-main \$CLASS \$@"
    EOF
    chmod +x $out/bin/spark-upload-scala

    cat > $out/bin/spark-upload-python <<EOF
    #!${bash}/bin/bash
    exec $out/bin/pyspark \$@
    EOF
    chmod +x $out/bin/spark-upload-python
  '';

  phases = "unpackPhase installPhase";

  meta = {
    description = "Spark cluster computing";
    homepage    = "http://spark.incubator.apache.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

{ stdenv
, lib
, makeWrapper
, gradle
, fetchFromGitHub
, python2
, jdk
, jre
, which
, curl
, git
, cacert
, mesos

# Aurora has 4 main components; the scheduler, executor, observer and client
# By default this package will install all of them but you can disable
# the components you don't need and only install the ones that make
# sense to you on the particular machine you are installing on.
, withScheduler ? true
, withExecutor ? true
, withObserver ? true
, withClient ? true
}:

let

    # Themos executor requires some .egg files from this version
    mesos_0_22_0 = lib.overrideDerivation mesos (attrs: rec {
      version = "0.22.0";

      src = fetchFromGitHub {
	owner = "apache";
	repo = "mesos";
	rev = version;
	sha256 = "0rkzb1zjby8xd97am4733j2fa82xq49adk8w9ysv005fri9lk2k6";
      };
    });

in stdenv.mkDerivation rec {
  name = "apache-aurora-${version}";

  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "aurora";
    rev = version;
    sha256 = "1gn4988nawxppf3jgwvvnbnip8acrcqz1pyhlp62p45y8zi89hnd";
  };

  buildInputs = [ makeWrapper python2 jdk jre which curl git gradle cacert ];

  preferLocalBuild = true;

  phases = with lib; [ "unpackPhase" "setupPhase" ]
                      ++ optional withClient "buildClient"
                      ++ optional withExecutor "buildExecutor"
                      ++ optional withObserver "buildObserver"
                      ++ optional withScheduler "buildScheduler"
                      ++ [ "installPhase" "fixupPhase" ];

  setupPhase = ''
    export HOME=$TMPDIR/$(mktemp -d .home.XXXXXXXXXX)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  buildClient = ''
    ./pants binary src/main/python/apache/aurora/admin:aurora_admin
    ./pants binary src/main/python/apache/aurora/client/cli:aurora
  '';

  buildExecutor = ''
    mkdir -p third_party/
    find ${mesos_0_22_0}/lib/python*/site-packages/ -name '*.egg' -exec cp {} third_party/ \;
    ./pants binary src/main/python/apache/aurora/executor/bin:gc_executor
    ./pants binary src/main/python/apache/aurora/executor/bin:thermos_executor
    ./pants binary src/main/python/apache/thermos/bin:thermos_runner

    python2 <<EOF
import contextlib
import zipfile
with contextlib.closing(zipfile.ZipFile("dist/thermos_executor.pex", "a")) as zf:
  zf.writestr("apache/aurora/executor/resources/__init__.py", "")
  zf.write("dist/thermos_runner.pex", "apache/aurora/executor/resources/thermos_runner.pex")
EOF

    chmod +x dist/thermos_executor.pex
  '';

  buildObserver = ''
    ./pants binary src/main/python/apache/thermos/observer/bin:thermos_observer
  '';

  buildScheduler = ''
    export GRADLE_USER_HOME=$TMPDIR
    gradle wrapper
    ./gradlew installDist
    substituteInPlace ./dist/install/aurora-scheduler/bin/aurora-scheduler \
      --replace /lib/ /share/${name}/
  '';

  installPhase = ''
    mkdir -p $out/bin

    # If the scheduler was built, install it
    if [[ -d ./dist/install/aurora-scheduler ]]; then
      mkdir -p $out/{bin,share/${name}}
      cp -v ./dist/install/aurora-scheduler/bin/aurora-scheduler $out/bin/
      cp -Rv ./dist/install/aurora-scheduler/etc $out/
      cp -Rv ./dist/install/aurora-scheduler/lib/* $out/share/${name}/
    fi

    # Install any built aurora tools
    for bin in dist/*.pex; do
      script=$(basename "$bin" .pex)
      script=$(echo "$script" | tr _ -)
      cp -v "$bin" $out/bin/$script
    done

    wrapProgram $out/bin/aurora-scheduler \
      --prefix JAVA_HOME : "${jre}" \
      --prefix PATH : "${which}/bin"
    '';

  meta = with lib; {
    homepage = http://aurora.apache.org;
    description = "Apache Aurora is a Mesos framework for long-running services and cron jobs";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}

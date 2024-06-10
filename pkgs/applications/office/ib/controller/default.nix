{ lib, stdenv, fetchFromGitHub, unzip, jdk, ib-tws, xpra }:

stdenv.mkDerivation rec {
  version = "2.14.0";
  pname = "ib-controller";

  src = fetchFromGitHub {
    owner = "ib-controller";
    repo = "ib-controller";
    rev = version;
    sha256 = "sha256-R175CKb3uErjBNe73HEFMI+bNmmuH2nWGraCSh5bXwc=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ jdk ib-tws ];

  installPhase = ''
    mkdir -p $out $out/bin $out/etc/ib/controller $out/share/IBController
    cp resources/*.jar $out/share/IBController/.
    cp resources/*.ini $out/etc/ib/controller/.
    classpath=""
    for jar in ${ib-tws}/share/IBJts/*.jar; do
      classpath="$classpath:$jar"
    done
    for jar in $out/share/IBController/*.jar; do
      classpath="$classpath:$jar"
    done
    # strings to use below; separated to avoid nix specific substitutions
    javaOptions={JAVA_OPTIONS:--Xmx1024M}
    ibProfileDir={IB_PROFILE_DIR:-~/IB/}
    cat<<EOF > $out/bin/ib-tws-c
    #!$SHELL
    if [[ \$1 == /* ]] || [[ \$1 == ./* ]]; then
      IB_USER_PROFILE=\`realpath \$1\`
      IB_USER_PROFILE_TITLE=\`basename \$1\`
    else
      if [[ x\$1 != "x" ]] && [[ \$1 != -* ]]; then
        IB_USER_PROFILE=\`realpath \$$ibProfileDir\$1\`
        IB_USER_PROFILE_TITLE=\$1
      else
        echo "ERROR: \"\$1\" is not a valid name of a profile."
        exit 1
      fi
    fi
    shift
    if [ ! -e \$IB_USER_PROFILE ]; then mkdir -p \$IB_USER_PROFILE; fi
    if [ ! -d \$IB_USER_PROFILE ]; then echo "ERROR: \$IB_USER_PROFILE must be a directory!" && echo 1; fi
    if [ ! -e \$IB_USER_PROFILE/jts.ini ]; then cp ${ib-tws}/etc/ib/tws/jts.ini \$IB_USER_PROFILE/. && chmod +w \$IB_USER_PROFILE/jts.ini; fi
    if [ ! -e \$IB_USER_PROFILE/IBController.ini ]; then cp $out/etc/ib/controller/IBController.ini \$IB_USER_PROFILE/. && chmod +w \$IB_USER_PROFILE/IBController.ini; fi
    if [[ \$1 == "-q" ]]; then
      if [ -f \$IB_USER_PROFILE/xpra/run ]; then
        ${xpra}/bin/xpra stop \`cat \$IB_USER_PROFILE/xpra/run\` --socket-dir=\$IB_USER_PROFILE/xpra/ &> /dev/null
      fi
      exit 0
    fi
    if [[ \$1 == "-d" ]] && [ ! -f \$IB_USER_PROFILE/xpra/run ]; then
      ( sleep infinity ) &
      WAIT_DUMMY_PID=\$!
      ( trap "" INT;
        DISPLAYNUM=100
        while [ -f /tmp/.X\$DISPLAYNUM-lock ]; do DISPLAYNUM=\$((\$DISPLAYNUM + 1)); done
        mkdir -p \$IB_USER_PROFILE/xpra
        cd \$IB_USER_PROFILE
        nohup ${xpra}/bin/xpra start :\$DISPLAYNUM \
          --socket-dir=\$IB_USER_PROFILE/xpra/ \
          --start-child="echo -n :\$DISPLAYNUM > \$IB_USER_PROFILE/xpra/run \
                         && kill \$WAIT_DUMMY_PID &> /dev/null \
                         && ${jdk}/bin/java -cp $classpath \$$javaOptions ibcontroller.IBController \$IB_USER_PROFILE/IBController.ini" \
          --exit-with-children \
          --no-pulseaudio \
          --no-mdns \
          --no-notification \
          --no-daemon \
          &> \$IB_USER_PROFILE/xpra/server.log
        rm -f \$IB_USER_PROFILE/xpra/run
        rm -f /tmp/.X\$DISPLAYNUM-lock
      ) &
      wait \$WAIT_DUMMY_PID
      exit 0
    fi
    if [ -f \$IB_USER_PROFILE/xpra/run ]; then
      ${xpra}/bin/xpra attach \`cat \$IB_USER_PROFILE/xpra/run\` --socket-dir=\$IB_USER_PROFILE/xpra/ \
      --windows \
      --no-speaker \
      --no-microphone \
      --no-tray \
      --title="\$IB_USER_PROFILE_TITLE: @title@" \
      &> \$IB_USER_PROFILE/xpra/client.log
    fi
    EOF
    chmod u+x $out/bin/ib-tws-c
    cat<<EOF > $out/bin/ib-gw-c
    #!$SHELL
    if [[ \$1 == /* ]] || [[ \$1 == ./* ]]; then
      IB_USER_PROFILE=\`realpath \$1\`
      IB_USER_PROFILE_TITLE=\`basename \$1\`
    else
      if [[ x\$1 != "x" ]] && [[ \$1 != -* ]]; then
        IB_USER_PROFILE=\`realpath \$$ibProfileDir\$1\`
        IB_USER_PROFILE_TITLE=\$1
      else
        echo "ERROR: \"\$1\" is not a valid name of a profile."
        exit 1
      fi
    fi
    shift
    if [ ! -e \$IB_USER_PROFILE ]; then mkdir -p \$IB_USER_PROFILE; fi
    if [ ! -d \$IB_USER_PROFILE ]; then echo "ERROR: \$IB_USER_PROFILE must be a directory!" && echo 1; fi
    if [ ! -e \$IB_USER_PROFILE/jts.ini ]; then cp ${ib-tws}/etc/ib/tws/jts.ini \$IB_USER_PROFILE/. && chmod +w \$IB_USER_PROFILE/jts.ini; fi
    if [ ! -e \$IB_USER_PROFILE/IBController.ini ]; then cp $out/etc/ib/controller/IBController.ini \$IB_USER_PROFILE/. && chmod +w \$IB_USER_PROFILE/IBController.ini; fi
    if [[ \$1 == "-q" ]]; then
      if [ -f \$IB_USER_PROFILE/xpra/run ]; then
        ${xpra}/bin/xpra stop \`cat \$IB_USER_PROFILE/xpra/run\` --socket-dir=\$IB_USER_PROFILE/xpra/ &> /dev/null
      fi
      exit 0
    fi
    if [[ \$1 == "-d" ]] && [ ! -f \$IB_USER_PROFILE/xpra/run ]; then
      ( sleep infinity ) &
      WAIT_DUMMY_PID=\$!
      ( trap "" INT;
        DISPLAYNUM=100
        while [ -f /tmp/.X\$DISPLAYNUM-lock ]; do DISPLAYNUM=\$((\$DISPLAYNUM + 1)); done
        mkdir -p \$IB_USER_PROFILE/xpra
        cd \$IB_USER_PROFILE
        nohup ${xpra}/bin/xpra start :\$DISPLAYNUM \
          --socket-dir=\$IB_USER_PROFILE/xpra/ \
          --start-child="echo -n :\$DISPLAYNUM > \$IB_USER_PROFILE/xpra/run \
                         && kill \$WAIT_DUMMY_PID &> /dev/null \
                         && ${jdk}/bin/java -cp $classpath \$$javaOptions ibcontroller.IBGatewayController \$IB_USER_PROFILE/IBController.ini" \
          --exit-with-children \
          --no-pulseaudio \
          --no-mdns \
          --no-notification \
          --no-daemon \
          &> \$IB_USER_PROFILE/xpra/server.log
        rm -f \$IB_USER_PROFILE/xpra/run
        rm -f /tmp/.X\$DISPLAYNUM-lock
      ) &
      wait \$WAIT_DUMMY_PID
      exit 0
    fi
    if [ -f \$IB_USER_PROFILE/xpra/run ]; then
      ${xpra}/bin/xpra attach \`cat \$IB_USER_PROFILE/xpra/run\` --socket-dir=\$IB_USER_PROFILE/xpra/ \
      --windows \
      --no-speaker \
      --no-microphone \
      --no-tray \
      --title="\$IB_USER_PROFILE_TITLE: @title@" \
      &> \$IB_USER_PROFILE/xpra/client.log
    fi
    EOF
    chmod u+x $out/bin/ib-gw-c
  '';


  meta = with lib; {
    description = "Automation Controller for the Trader Work Station of Interactive Brokers";
    homepage = "https://github.com/ib-controller/ib-controller";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

{
  lib,
  stdenv,
  requireFile,
  jdk,
}:

stdenv.mkDerivation rec {
  version = "9542";
  pname = "ib-tws";

  src = requireFile rec {
    name = "ibtws_${version}.jar";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Download the TWS from
      https://download2.interactivebrokers.com/download/unixmacosx_latest.jar,
      rename the file to ${name}, and add it to the nix store with
      "nix-prefetch-url file://\$PWD/${name}".
    '';
    sha256 = "1a2jiwwnr5g3xfba1a89c257bdbnq4zglri8hz021vk7f6s4rlrf";
  };

  buildInputs = [ jdk ];

  buildPhase = ''
    jar -xf IBJts/jts.jar
    cp trader/common/images/ibapp_icon.gif ibtws_icon.gif
  '';

  unpackPhase = ''
    jar xf ${src}
  '';

  installPhase = ''
    mkdir -p $out $out/bin $out/etc/ib/tws $out/share/IBJts $out/share/icons
    cp IBJts/*.jar $out/share/IBJts/.
    cp IBJts/*.ini $out/etc/ib/tws/.
    cp ibtws_icon.gif $out/share/icons/.
    classpath=""
    for jar in $out/share/IBJts/*.jar; do
      classpath="$classpath:$jar"
    done
    # strings to use below; separated to avoid nix specific substitutions
    javaOptions={JAVA_OPTIONS:-'-Xmx1024M -Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.xrender=True -Dsun.java2d.opengl=False'}
    # OTHER JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java
    ibProfileDir={IB_PROFILE_DIR:-~/IB/}
    cat<<EOF > $out/bin/ib-tws
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
    if [ ! -e \$IB_USER_PROFILE/jts.ini ]; then cp $out/etc/ib/tws/jts.ini \$IB_USER_PROFILE/. && chmod +w \$IB_USER_PROFILE/jts.ini; fi
    ${jdk}/bin/java -cp $classpath \$$javaOptions jclient.LoginFrame \$IB_USER_PROFILE
    EOF
    chmod u+x $out/bin/ib-tws
    cat<<EOF > $out/bin/ib-gw
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
    if [ ! -e \$IB_USER_PROFILE/jts.ini ]; then cp $out/etc/ib/tws/jts.ini \$IB_USER_PROFILE/. && chmod +w \$IB_USER_PROFILE/jts.ini; fi
    ${jdk}/bin/java -cp $classpath -Dsun.java2d.noddraw=true \$$javaOptions ibgateway.GWClient \$IB_USER_PROFILE
    EOF
    chmod u+x $out/bin/ib-gw
  '';

  meta = with lib; {
    description = "Trader Work Station of Interactive Brokers";
    homepage = "https://www.interactivebrokers.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

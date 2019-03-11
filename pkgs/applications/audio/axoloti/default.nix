{ stdenv, fetchFromGitHub, fetchurl, makeWrapper, unzip
, gnumake, gcc-arm-embedded, binutils-arm-embedded
, dfu-util-axoloti, jdk, ant, libfaketime }:

stdenv.mkDerivation rec {
  version = "1.0.12-2";
  name = "axoloti-${version}";

  src = fetchFromGitHub {
    owner = "axoloti";
    repo = "axoloti";
    rev = "${version}";
    sha256 = "1qffis277wshldr3i939b0r2x3a2mlr53samxqmr2nk1sfm2b4w9";
  };

  chibi_version = "2.6.9";
  chibi_name = "ChibiOS_${chibi_version}";

  chibios = fetchurl {
    url = "mirror://sourceforge/project/chibios/ChibiOS_RT%20stable/Version%20${chibi_version}/${chibi_name}.zip";
    sha256 = "0lb5s8pkj80mqhsy47mmq0lqk34s2a2m3xagzihalvabwd0frhlj";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
    gcc-arm-embedded
    binutils-arm-embedded
    dfu-util-axoloti
    ant
  ];
  buildInputs = [jdk libfaketime ];

  patchPhase = ''
    unzip ${chibios}
    mv ${chibi_name} chibios
    (cd chibios/ext; unzip -q -o fatfs-0.9-patched.zip)

    # Remove source of non-determinism in ChibiOS
    substituteInPlace "chibios/os/various/shell.c" \
      --replace "#ifdef __DATE__" "#if 0"

    # Hardcode path to "make"
    for f in "firmware/compile_firmware_linux.sh" \
             "firmware/compile_patch_linux.sh"; do
      substituteInPlace "$f" \
        --replace "make" "${gnumake}/bin/make"
    done

    # Hardcode dfu-util path
    substituteInPlace "platform_linux/upload_fw_dfu.sh" \
      --replace "/bin/dfu-util" ""
    substituteInPlace "platform_linux/upload_fw_dfu.sh" \
      --replace "./dfu-util" "${dfu-util-axoloti}/bin/dfu-util"

    # Fix build version
    substituteInPlace "build.xml" \
      --replace "(git missing)" "${version}"

    # Remove build time
    substituteInPlace "build.xml" \
      --replace "<tstamp>" ""
    substituteInPlace "build.xml" \
      --replace \
        '<format property="build.time" pattern="dd/MM/yyyy HH:mm:ss z"/>' \
        '<property name="build.time" value=""/>'
    substituteInPlace "build.xml" \
      --replace "</tstamp>" ""
    substituteInPlace "build.xml" \
      --replace \
       '{line.separator}</echo>' \
       '{line.separator}</echo> <touch file="src/main/java/axoloti/Version.java" millis="0" />'
  '';

  buildPhase = ''
    find . -exec touch -d '1970-01-01 00:00' {} \;
    (cd platform_linux; sh compile_firmware.sh)
    faketime "1970-01-01 00:00:00" ant -Dbuild.runtime=true
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/axoloti

    cp -r doc firmware chibios platform_linux CMSIS *.txt $out/share/axoloti/
    install -vD dist/Axoloti.jar $out/share/axoloti/

    makeWrapper ${jdk}/bin/java $out/bin/axoloti --add-flags "-Daxoloti_release=$out/share/axoloti -Daxoloti_runtime=$out/share/axoloti -jar $out/share/axoloti/Axoloti.jar"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.axoloti.com;
    description = ''
      Sketching embedded digital audio algorithms.

      To fix permissions of the Axoloti USB device node, add a similar udev rule to <literal>services.udev.extraRules</literal>:
      <literal>SUBSYSTEM=="usb", ATTR{idVendor}=="16c0", ATTR{idProduct}=="0442", OWNER="someuser", GROUP="somegroup"</literal>
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}

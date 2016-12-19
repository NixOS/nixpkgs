{ stdenv, fetchurl, libsaneUDevRuleNumber ? "49"}:

stdenv.mkDerivation rec {
  name = "brother-udev-rule-type1-1.0.0-1";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf006654/${name}.all.deb";
    sha256 = "0i0x5jw135pli4jl9mgnr5n2rrdvml57nw84yq2999r4frza53xi";
  };

  dontBuild = true;

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  /*
    Fix the following error:

    ~~~
    invalid rule 49-brother-libsane-type1.rules
    unknown key 'SYSFS{idVendor}'
    ~~~

    Apparently the udev rules syntax has change and the SYSFS key has to
    be changed to ATTR.

    See:

     -  <http://ubuntuforums.org/showthread.php?t=1496878>
     -  <http://www.planet-libre.org/index.php?post_id=10937>
  */
  patchPhase = ''
    sed -i -e s/SYSFS/ATTR/g opt/brother/scanner/udev-rules/type1/*.rules
  '';

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp opt/brother/scanner/udev-rules/type1/NN-brother-mfp-type1.rules \
      $out/etc/udev/rules.d/${libsaneUDevRuleNumber}-brother-libsane-type1.rules
    chmod 644 $out/etc/udev/rules.d/${libsaneUDevRuleNumber}-brother-libsane-type1.rules
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "Brother type1 scanners udev rules";
    homepage = http://www.brother.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };
}

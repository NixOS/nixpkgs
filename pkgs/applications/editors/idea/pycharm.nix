{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git, python
}:

let

  buildPycharm =
  { name, dirName, version, build, src, description, license }:

  stdenv.mkDerivation rec {
    inherit name dirName build src license;
    pycharmItem = makeDesktopItem {
      name = "pycharm";
      exec = "pycharm";
      comment = "Powerful Python and Django IDE";
      desktopName = "PyCharm";
      genericName = "Powerful Python and Django IDE";
      categories = "Application;Development;";
    };

    buildInputs = [ makeWrapper patchelf p7zip ];

    buildCommand = ''
      tar xvzf $src
      mkdir -p $out
      cp -a $dirName $out

      interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)

      7z x $out/$dirName/lib/snappy-java-1.0.5.jar
      rm $out/$dirName/lib/snappy-java-1.0.5.jar
      if [ "${stdenv.system}" == "x86_64-linux" ];then
        patchelf --set-interpreter $interpreter $out/$dirName/bin/fsnotifier64
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib64/ org/xerial/snappy/native/Linux/amd64/libsnappyjava.so
      else
        patchelf --set-interpreter $interpreter $out/$dirName/bin/fsnotifier
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib/ org/xerial/snappy/native/Linux/i386/libsnappyjava.so
      fi
      7z a -tzip $out/$dirName/lib/snappy-java-1.0.5.jar .

      mkdir -p $out/bin

      jdk=${jdk}/lib/openjdk

      makeWrapper $out/$dirName/bin/pycharm.sh $out/bin/pycharm \
        --prefix PATH : ${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin \
        --prefix LD_RUN_PATH : ${stdenv.gcc.gcc}/lib/ \
        --prefix JDK_HOME : $jdk \
        --prefix PYCHARM_JDK : $jdk

        mkdir -p $out/share/applications
        cp ${pycharmItem}/share/applications/* $out/share/applications
        patchShebangs $out

      mkdir "$out"/nix-support
      echo ${python} >> "$out"/nix-support/propagated-user-env-packages
    '';

    meta = {
      homepage = "https://www.jetbrains.com/pycharm/";
      inherit description;
      inherit license;
      maintainers = [ stdenv.lib.maintainers.jgeerds ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

in {

  pycharm_community_313 = buildPycharm rec {
    name = "pycharm-community-${version}";
    dirName = "${name}";
    version = "3.1.3";
    build = "133.1347";
    description = "PyCharm 3.1 Community Edition";
    license = stdenv.lib.licenses.asl20.shortName;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "f671ee4c99207c179f168b5b98fa23afe90a94c3a3914367b95a46b0c2881b23";
    };
  };

  pycharm_community_341 = buildPycharm rec {
    name = "pycharm-community-${version}";
    dirName = "${name}";
    version = "3.4.1";
    build = "135.1057";
    description = "PyCharm 3.4 Community Edition";
    license = stdenv.lib.licenses.asl20.shortName;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "96427b1e842e7c09141ec4d3ede627c5ca7d821c0d6c98169b56a34f9035ef64";
    };
  };

  pycharm_professional_313 = buildPycharm rec {
    name = "pycharm-professional-${version}";
    dirName = "pycharm-${version}";
    version = "3.1.3";
    build = "133.1347";
    description = "PyCharm 3.1 Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "e0c2db8f18cb825a95de6ddc4b0b9f93c5643bf34cca9f1b3c2fa37fd7c14f11";
    };
  };

  pycharm_professional_341 = buildPycharm rec {
    name = "pycharm-professional-${version}";
    dirName = "pycharm-${version}";
    version = "3.4.1";
    build = "135.1057";
    description = "PyCharm 3.4 Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "e4f85f3248e8985ac9f8c326543f979b47ba1d7ac6b128a2cf2b3eb8ec545d2b";
    };
  };
}

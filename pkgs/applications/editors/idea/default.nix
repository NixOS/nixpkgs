{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git, python
}:

assert stdenv.isLinux;

let

  mkIdeaProduct =
  { name, product, version, build, src, meta }:

  let loName = stdenv.lib.toLower product;
      hiName = stdenv.lib.toUpper product; in

  with stdenv; lib.makeOverridable mkDerivation rec {
    inherit name build src meta;
    desktopItem = makeDesktopItem {
      name = loName;
      exec = loName;
      comment = meta.longDescription;
      desktopName = product;
      genericName = meta.description;
      categories = "Application;Development;";
      icon = loName;
    };

    buildInputs = [ makeWrapper patchelf p7zip ];

    patchPhase = ''
      interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
      snappyPath="lib/snappy-java-1.0.5"

      7z x -o"$snappyPath" "$snappyPath.jar"
      if [ "${stdenv.system}" == "x86_64-linux" ]; then
        patchelf --set-interpreter "$interpreter" bin/fsnotifier64
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib64/ "$snappyPath/org/xerial/snappy/native/Linux/amd64/libsnappyjava.so"
      else
        patchelf --set-interpreter "$interpreter" bin/fsnotifier
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib/ "$snappyPath/org/xerial/snappy/native/Linux/i386/libsnappyjava.so"
      fi
      7z a -tzip "$snappyPath.jar" ./"$snappyPath"/*
      rm -vr "$snappyPath"
    '';

    installPhase = ''
      mkdir -vp "$out/bin" "$out/$name" "$out/share/pixmaps"
      cp -va . "$out/$name"
      ln -s "$out/$name/bin/${loName}.png" "$out/share/pixmaps/"

      [ -d ${jdk}/lib/openjdk ] \
        && jdk=${jdk}/lib/openjdk \
        || jdk=${jdk}

      makeWrapper "$out/$name/bin/${loName}.sh" "$out/bin/${loName}" \
        --prefix PATH : "${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin" \
        --prefix LD_RUN_PATH : "${stdenv.gcc.gcc}/lib/" \
        --prefix JDK_HOME : "$jdk" \
        --prefix ${hiName}_JDK : "$jdk"

      cp -a "${desktopItem}"/* "$out"
    '';

  };

  buildPycharm = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      product = "PyCharm";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/pycharm/";
        inherit description license;
        longDescription = ''
          Python IDE with complete set of tools for productive
          development with Python programming language. In addition, the
          IDE provides high-class capabilities for professional Web
          development with Django framework and Google App Engine. It
          has powerful coding assistance, navigation, a lot of
          refactoring features, tight integration with various Version
          Control Systems, Unit testing, powerful all-singing
          all-dancing Debugger and entire customization. PyCharm is
          developer driven IDE. It was developed with the aim of
          providing you almost everything you need for your comfortable
          and productive development!
        '';
        maintainers = with maintainers; [ jgeerds ];
        platforms = platforms.linux;
      };
    }).override {
      propagatedUserEnvPkgs = [ python ];
    };

  buildIdea = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      product = "IDEA";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/idea/";
        inherit description license;
        longDescription = ''
          IDE for Java SE, Groovy & Scala development Powerful
          environment for building Google Android apps Integration
          with JUnit, TestNG, popular SCMs, Ant & Maven.
        '';
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

in

{

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "13.1.4b";
    build = "IC-135.1230";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "8b4ee25fd2934e06b87230b50e1474183ed4b331c1626a7fee69b96294d9616d";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "13.1.4b";
    build = "IU-135.1230";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "84660d97c9c3e4e7cfd6c2708f4685dc7322157f1e1c2888feac64df119f0606";
    };
  };

  pycharm-community-313 = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "3.1.3";
    build = "133.1347";
    description = "PyCharm 3.1 Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "f671ee4c99207c179f168b5b98fa23afe90a94c3a3914367b95a46b0c2881b23";
    };
  };

  pycharm-community-341 = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "3.4.1";
    build = "135.1057";
    description = "PyCharm 3.4 Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "96427b1e842e7c09141ec4d3ede627c5ca7d821c0d6c98169b56a34f9035ef64";
    };
  };

  pycharm-professional-313 = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "3.1.3";
    build = "133.1347";
    description = "PyCharm 3.1 Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "e0c2db8f18cb825a95de6ddc4b0b9f93c5643bf34cca9f1b3c2fa37fd7c14f11";
    };
  };

  pycharm-professional-341 = buildPycharm rec {
    name = "pycharm-professional-${version}";
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
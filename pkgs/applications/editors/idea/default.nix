{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git, python, unzip
}:

assert stdenv.isLinux;

let

  mkIdeaProduct =
  { name, product, version, build, src, meta, patchSnappy ? true }:

  let loName = stdenv.lib.toLower product;
      hiName = stdenv.lib.toUpper product; in

  with stdenv; lib.makeOverridable mkDerivation rec {
    inherit name build src meta;
    desktopItem = makeDesktopItem {
      name = loName;
      exec = loName;
      comment = lib.replaceChars ["\n"] [" "] meta.longDescription;
      desktopName = product;
      genericName = meta.description;
      categories = "Application;Development;";
      icon = loName;
    };

    buildInputs = [ makeWrapper patchelf p7zip unzip ];

    patchPhase = lib.concatStringsSep "\n" [
      ''
        get_file_size() {
          local fname="$1"
          echo $(ls -l $fname | cut -d ' ' -f5)
        }

        munge_size_hack() {
          local fname="$1"
          local size="$2"
          strip $fname
          truncate --size=$size $fname
        }

        interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
        if [ "${stdenv.system}" == "x86_64-linux" ]; then
          target_size=$(get_file_size bin/fsnotifier64)
          patchelf --set-interpreter "$interpreter" bin/fsnotifier64
          munge_size_hack bin/fsnotifier64 $target_size
        else
          target_size=$(get_file_size bin/fsnotifier)
          patchelf --set-interpreter "$interpreter" bin/fsnotifier
          munge_size_hack bin/fsnotifier $target_size
        fi
      ''

      (lib.optionalString patchSnappy ''
        snappyPath="lib/snappy-java-1.0.5"
        7z x -o"$snappyPath" "$snappyPath.jar"
        if [ "${stdenv.system}" == "x86_64-linux" ]; then
          patchelf --set-rpath ${stdenv.cc.gcc}/lib64 "$snappyPath/org/xerial/snappy/native/Linux/amd64/libsnappyjava.so"
        else
          patchelf --set-rpath ${stdenv.cc.gcc}/lib "$snappyPath/org/xerial/snappy/native/Linux/i386/libsnappyjava.so"
        fi
        7z a -tzip "$snappyPath.jar" ./"$snappyPath"/*
        rm -vr "$snappyPath"
      '')
    ];

    installPhase = ''
      mkdir -vp "$out/bin" "$out/$name" "$out/share/pixmaps"
      cp -va . "$out/$name"
      ln -s "$out/$name/bin/${loName}.png" "$out/share/pixmaps/"

      jdk=${jdk.home}

      makeWrapper "$out/$name/bin/${loName}.sh" "$out/bin/${loName}" \
        --prefix PATH : "${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin" \
        --prefix LD_RUN_PATH : "${stdenv.cc.gcc}/lib/" \
        --prefix JDK_HOME : "$jdk" \
        --prefix ${hiName}_JDK : "$jdk"

      cp -a "${desktopItem}"/* "$out"
    '';

  };

  buildAndroidStudio = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      product = "Studio";
      meta = with stdenv.lib; {
        homepage = https://developer.android.com/sdk/installing/studio.html;
        inherit description license;
        longDescription = ''
          Android development environment based on IntelliJ
          IDEA providing new features and improvements over
          Eclipse ADT and will be the official Android IDE
          once it's ready.
        '';
        platforms = platforms.linux;
        maintainers = with maintainers; [ edwtjo ];
      };
    });

  buildClion = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      patchSnappy = false;
      product = "CLion";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/clion/";
        inherit description license;
        longDescription = ''
          Enhancing productivity for every C and C++
          developer on Linux, OS X and Windows.
        '';
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildIdea = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      patchSnappy = false;
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

  buildRubyMine = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      patchSnappy = false;
      product = "RubyMine";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/ruby/";
        inherit description license;
        longDescription = description;
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildPhpStorm = { name, version, build, src, license, description }:
    (mkIdeaProduct {
      inherit name version build src;
      product = "PhpStorm";
      patchSnappy = false;
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/phpstorm/";
        inherit description license;
        longDescription = ''
          PhpStorm provides an editor for PHP, HTML and JavaScript
          with on-the-fly code analysis, error prevention and
          automated refactorings for PHP and JavaScript code.
        '';
        maintainers = with maintainers; [ schristo ];
        platforms = platforms.linux;
      };
    });

  buildPycharm = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
      patchSnappy = false;
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

in

{

  android-studio = buildAndroidStudio rec {
    name = "android-studio-${version}";
    version = "1.0.2";
    build = "135.1653844";
    description = "Android development environment based on IntelliJ IDEA";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}" +
            "/android-studio-ide-${build}-linux.zip";
      sha256 = "0y20gp5444c2lwyzhlppjpkb657qbgpskj31lwyfhx6xyqy83159";
    };
  };

  clion = buildClion rec {
    name = "clion";
    version = "eap";
    build = "140.1221.2";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform.";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/cpp/${name}-${build}.tar.gz";
      sha256 = "0gf809plnw89dgn47j6hsh5nv0bpdynjnl1rg8wv7jaz2zx9bqcg";
    };
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "14.0.2";
    build = "IC-139.659";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "0g8f66bdxdmsbv2r1jc308by5ca92ifczprf0gwy5bs2xsvxxwlf";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "14.0.2";
    build = "IU-139.659";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "0swd3lyrlcdlsgp350sa741bkmndlck1ss429f9faf3hm4s2y0k5";
    };
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "7.0";
    build = "135.1104";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "0xsx44gaddarkw5k4yjidzwkayf2xvsxklfzdnzcck4rg4vyk4v4";
    };
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "4.0.1";
    build = "139.574";
    description = "PyCharm 4.0 Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "0jh0sxi5dpgpw7ga018fby7zvb4i9k49vwl8422lfcrgckdz9nv2";
    };
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "4.0.1";
    build = "139.574";
    description = "PyCharm 4.0 Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "04yjhg6vi2kz00sy8zg4wkz26ai90vbp0cnd850ynsab0jsy24w4";
    };
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "8.0.2";
    build = "PS-139.732";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "01b8vx6swi71sd0rc7i1jnicilqp11ch3zrm8gwb6xh1pmmpdirf";
    };
  };

}

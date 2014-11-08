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
          patchelf --set-rpath ${stdenv.gcc.gcc}/lib64 "$snappyPath/org/xerial/snappy/native/Linux/amd64/libsnappyjava.so"
        else
          patchelf --set-rpath ${stdenv.gcc.gcc}/lib "$snappyPath/org/xerial/snappy/native/Linux/i386/libsnappyjava.so"
        fi
        7z a -tzip "$snappyPath.jar" ./"$snappyPath"/*
        rm -vr "$snappyPath"
      '')
    ];

    installPhase = ''
      mkdir -vp "$out/bin" "$out/$name" "$out/share/pixmaps"
      cp -va . "$out/$name"
      ln -s "$out/$name/bin/${loName}.png" "$out/share/pixmaps/"

      [ -d ${jdk}/lib/openjdk ] \
        && jdk=${jdk}/lib/openjdk \
        || jdk=${jdk}

      if [ "${stdenv.system}" == "x86_64-linux" ]; then
        makeWrapper "$out/$name/bin/fsnotifier64" "$out/bin/fsnotifier64"
      else
        makeWrapper "$out/$name/bin/fsnotifier" "$out/bin/fsnotifier"
      fi

      makeWrapper "$out/$name/bin/${loName}.sh" "$out/bin/${loName}" \
        --prefix PATH : "${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin" \
        --prefix LD_RUN_PATH : "${stdenv.gcc.gcc}/lib/" \
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
    version = "0.8.12";
    build = "135.1503853";
    description = "Android development environment based on IntelliJ IDEA";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}" +
            "/android-studio-ide-${build}-linux.zip";
      sha256 = "225c8b2f90b9159c465eae5797132350660994184a568c631d4383313a510695";
    };
  };

  clion = buildClion rec {
    name = "clion";
    version = "eap";
    build = "138.2344.17";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform.";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/cpp/${name}-${build}.tar.gz";
      sha256 = "4b568d31132a787b748bc41c69b614dcd90229db69b02406677361bc077efab3";
    };
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "14";
    build = "IC-139.224";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "72e1e7659aa90c0b520eed8190fa96899e26bde7448a9fe4ed43929ef25c508a";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "14";
    build = "IU-139.224";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "e1c86f0b39e74b3468f7512d299ad9e0ca0c492316e996e65089368aff5446c6";
    };
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "6.3.3";
    build = "135.1104";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "58d555c2702a93fe62f3809a5cc34e566ecce0c3f1f15daaf87744402157dfac";
    };
  };

  pycharm-community = buildPycharm rec {
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

  pycharm-professional = buildPycharm rec {
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

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "8.0.1";
    build = "PS-138.2001";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0d46442aa32174fe16846c3c31428178ab69b827d2e0ce31f633f13b64c01afc";
    };
  };

}

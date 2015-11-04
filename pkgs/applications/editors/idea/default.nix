{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git, python, unzip, androidsdk
}:

assert stdenv.isLinux;

let

  mkIdeaProduct = with stdenv.lib;
  { name, product, version, build, src, meta }:

  let loName = toLower product;
      hiName = toUpper product;
      execName = concatStringsSep "-" (init (splitString "-" name));
  in

  with stdenv; lib.makeOverridable mkDerivation rec {
    inherit name build src meta;
    desktopItem = makeDesktopItem {
      name = execName;
      exec = execName;
      comment = lib.replaceChars ["\n"] [" "] meta.longDescription;
      desktopName = product;
      genericName = meta.description;
      categories = "Application;Development;";
      icon = execName;
    };

    buildInputs = [ makeWrapper patchelf p7zip unzip ];

    patchPhase = ''
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
    '';

    installPhase = ''
      mkdir -p $out/{bin,$name,share/pixmaps,libexec/${name}}
      cp -a . $out/$name
      ln -s $out/$name/bin/${loName}.png $out/share/pixmaps/${execName}.png
      mv bin/fsnotifier* $out/libexec/${name}/.

      jdk=${jdk.home}
      item=${desktopItem}

      makeWrapper "$out/$name/bin/${loName}.sh" "$out/bin/${execName}" \
        --prefix PATH : "$out/libexec/${name}:${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin" \
        --set JDK_HOME "$jdk" \
        --set ${hiName}_JDK "$jdk" \
        --set ANDROID_JAVA_HOME "$jdk" \
        --set JAVA_HOME "$jdk"

      ln -s "$item/share/applications" $out/share
    '';

  };

  buildAndroidStudio = { name, version, build, src, license, description }:
    let drv = (mkIdeaProduct rec {
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
    in stdenv.lib.overrideDerivation drv (x : {
      buildInputs = x.buildInputs ++ [ makeWrapper ];
      installPhase = x.installPhase +  ''
        wrapProgram "$out/bin/android-studio" \
          --set ANDROID_HOME "${androidsdk}/libexec/android-sdk-linux/"
      '';
    });

  buildClion = { name, version, build, src, license, description }:
    (mkIdeaProduct rec {
      inherit name version build src;
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

  buildWebStorm = { name, version, build, src, license, description }:
    (mkIdeaProduct {
      inherit name version build src;
      product = "WebStorm";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/webstorm/";
        inherit description license;
        longDescription = ''
          WebStorm provides an editor for HTML, JavaScript (incl. Node.js),
          and CSS with on-the-fly code analysis, error prevention and
          automated refactorings for JavaScript code.
        '';
        maintainers = with maintainers; [ abaldeau ];
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
    version = "1.4.0.10";
    build = "141.2288178";
    description = "Android development environment based on IntelliJ IDEA";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}" +
            "/android-studio-ide-${build}-linux.zip";
      sha256 = "04zzzk6xlvzip6klxvs4zz2wyfyn3w9b5jwilzbqjidiz2d3va57";
    };
  };

  clion = buildClion rec {
    name = "clion-${version}";
    version = "1.0.4";
    build = "141.874";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/${name}.tar.gz";
      sha256 = "1cz59h2znzjy7zncc049f2w30kc89rvmk7l51a1y6ymf9s7cj4cm";
    };
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "15.0";
    build = "IC-143.381";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "0d39ipwji76gkc7w5bcl7a94kdz5cwmcnwmvq1lzm06v43jjq51s";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "15.0";
    build = "IU-143.381";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "1hw8hqpzkdlp0ilax6anzjybhmjb40s16jblyplqpah065pc8rja";
    };
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "7.1.2";
    build = "141.1119";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "1gz14lv5jhnrnshp7lkx3wgrdf0y60abs4q78yhv2x9dc6ld1gmj";
    };
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "5.0";
    build = "143.589";
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download-cf.jetbrains.com/python/${name}.tar.gz";
      sha256 = "01q51m6rpyw296imiglbadzfr0r91wvyrxdid683yl7f5v73wzwh";
    };
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "5.0";
    build = "143.589";
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download-cf.jetbrains.com/python/${name}.tar.gz";
      sha256 = "16lwg00dl03gwj4dqihdrn15p1fy8513srw2dslna1w1glfajv06";
    };
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "9.0";
    build = "PS-141.1912";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "1n6p8xiv0nrs6yf0250mpga291msnrfamv573dva9f17cc3df2pp";
    };
  };

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "10.0.4";
    build = "141.1550";
    description = "Professional IDE for Web and JavaScript devlopment";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "171i544ssvjnbr1vq6ncxlj38swsygacavsa427qa4s5wzyvdipj";
    };
  };

}

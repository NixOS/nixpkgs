{ stdenv, callPackage, fetchurl, makeDesktopItem, makeWrapper, patchelf
, coreutils, gnugrep, which, git, python, unzip, p7zip
, androidsdk, jdk
}:

assert stdenv.isLinux;

let

  bnumber = with stdenv.lib; build: last (splitString "-" build);
  mkIdeaProduct = callPackage ./common.nix { };

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
    version = "2.0.0.0";
    build = "143.2443734";
    description = "Android development environment based on IntelliJ IDEA";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}" +
            "/android-studio-ide-${build}-linux.zip";
      sha256 = "0j6bi87hb5jxjwfhfya64s673vdkdslsqc6sqa4zl97sabvafk2w";
    };
  };

  clion = buildClion rec {
    name = "clion-${version}";
    version = "1.2.4";
    build = "143.1186";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/${name}.tar.gz";
      sha256 = "0asjgfshbximjk6i57fz3d2ykby5qw5x6nhw91cpzrzszc59dmm2";
    };
  };

  idea14-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "14.1.6";
    build = "IC-141.3056.4";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "157969b37sbafby1r1gva2xm3a3y0dgj7pisgxmk8k1d5rgncvil";
    };
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2016.1";
    build = "IC-145.258.11";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1grgyaapsbf7xn0m18x6fgghjh9n1n2zblz9608g9qgx5p28kn6q";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2016.1";
    build = "IU-145.258.11";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "15ybqdy311wi3iqi7bzk798cd91jpl73ngl86kzwr68d24nyy3zb";
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
    version = "5.0.3";
    build = "143.1559.1";
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1xb3qxhl8ln488v0hmjqkzpyypm7wh941c7syi4cs7plbdp6w4c2";
    };
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "5.0.3";
    build = "143.1559.1";
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1v2g9867nn3id1zfbg4zwj0c0z9d72rl9c1dz6vs2c4j0y4gy9xl";
    };
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "10.0.1";
    build = "PS-143.382";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "12bqil8pxzmbv8a7pxn2529ph2x7szr3wvkvgxaisydm463kpdk8";
    };
  };

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "10.0.4";
    build = "141.1550";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "171i544ssvjnbr1vq6ncxlj38swsygacavsa427qa4s5wzyvdipj";
    };
  };

}

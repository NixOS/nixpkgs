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

  android-studio = let buildNumber = "143.2821654"; in buildAndroidStudio rec {
    name = "android-studio-${version}";
    version = "2.1.1.0";
    build = "AI-${buildNumber}";
    description = "Android development environment based on IntelliJ IDEA";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}" +
            "/android-studio-ide-${buildNumber}-linux.zip";
      sha256 = "1zxxzyhny7j4vzlydrhwz3g8l8zcml84mhkcf5ckx8xr50j3m101";
    };
  };

  clion = buildClion rec {
    name = "clion-${version}";
    version = "1.2.5";
    build = "CL-143.2370.46";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/${name}.tar.gz";
      sha256 = "0ll1rcnnbd1if6x5rp3qw35lvp5zdzmvyg9n1lha89i34xiw36jp";
    };
  };

  idea14-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "14.1.7";
    build = "IC-141.3058.30";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1i4mdjm9dd6zvxlpdgd3bqg45ir0cfc9hl55cdc0hg5qwbz683fz";
    };
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2016.1.1";
    build = "IC-145.597";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1r0kvq8vk8ln4cabqjvfqp0lfy9vf8c8vddh76sd41d635pamba6";
    };
  };

  idea15-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "15.0.5";
    build = "IU-143.2332.3";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "1hvc5cmbfpp0qad0236ffh3g7zwfk64rh5bkkb750h3387jz7nr2";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2016.1.1";
    build = "IU-145.597";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "d5a7d2d657fe2ad170716054c6ccd164e509cf50ee6eee8b61fe3490071940df";
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
    version = "2016.1.2";
    build = "145.844";
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1kxwjg5l2fzpn6hr0iir0dv1n5l02jl02aff9wrj95186wxivg3a";
    };
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2016.1.2";
    build = "145.844";
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1kwi9d80r2yp5ivbvslrj70iam966rv4a8diajbwpcc26m7rj3kk";
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

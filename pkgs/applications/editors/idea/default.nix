{ stdenv, callPackage, fetchurl, makeDesktopItem, makeWrapper, patchelf
, coreutils, gnugrep, which, git, python, unzip, p7zip
, androidsdk, jdk
}:

assert stdenv.isLinux;

let
  mkIdeaProduct = callPackage ./common.nix { };

  buildClion = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct rec {
      inherit name version src wmClass jdk;
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

  buildIdea = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct rec {
      inherit name version src wmClass jdk;
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

  buildRubyMine = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct rec {
      inherit name version src wmClass jdk;
      product = "RubyMine";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/ruby/";
        inherit description license;
        longDescription = description;
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildPhpStorm = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct {
      inherit name version src wmClass jdk;
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

  buildWebStorm = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct {
      inherit name version src wmClass jdk;
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

  buildPycharm = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct rec {
      inherit name version src wmClass jdk;
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
  clion = buildClion rec {
    name = "clion-${version}";
    version = "2016.2.2";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "06aq3lfccki9203gjvibzj3gn9d82pc6s5z0m3fnf049zxk58ndi";
    };
    wmClass = "jetbrains-clion";
  };

  clion1 = buildClion rec {
    name = "clion-${version}";
    version = "1.2.5";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/${name}.tar.gz";
      sha256 = "0ll1rcnnbd1if6x5rp3qw35lvp5zdzmvyg9n1lha89i34xiw36jp";
    };
    wmClass = "jetbrains-clion";
  };

  idea14-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "14.1.7";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1i4mdjm9dd6zvxlpdgd3bqg45ir0cfc9hl55cdc0hg5qwbz683fz";
    };
    wmClass = "jetbrains-idea-ce";
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2016.2.4";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "0hk7z402qvkaa6hkhh4wsqxki2bnai5qkd2r0ngvy8kd71svrldz";
    };
    wmClass = "jetbrains-idea-ce";
  };

  idea14-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "14.1.7";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "1hhga1i2zbsipgq283gn19kv9n94inhr1bxh2yx19gz7yr4r49d2";
    };
    wmClass = "jetbrains-idea";
  };

  idea15-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "15.0.6";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "012aap2qn0jx4x34bdv9ivrsr86vvf683srb5vpj27hc4l6rw6ll";
    };
    wmClass = "jetbrains-idea";
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2016.2.4";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "165nchdnbyp85r2w0riv87j77lb7r492dkwrvm8q7qjnlfgznh7r";
    };
    wmClass = "jetbrains-idea";
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "2016.2.2";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "1ck4axjbrvq2n1j2rvf9a2f7dqvalg2b8sqy9n9qkzdn04szaqsl";
    };
    wmClass = "jetbrains-rubymine";
  };

  ruby-mine7 = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "7.1.5";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "04fcxj1xlap9mxmwf051s926p2darlj5kwl4lms2gy5d8b2lhd5l";
    };
    wmClass = "jetbrains-rubymine";
  };

  ruby-mine8 = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "8.0.4";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "0hipxib7377232w1jbf8h98bmh0djkllsrq3lq0w3fdxqglma43a";
    };
    wmClass = "jetbrains-rubymine";
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "2016.2.2";
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1v6vy4xh0n8wdjc25clxg57z7ria11x1zdba4j1hjs2z6l80kxbb";
    };
    wmClass = "jetbrains-pycharm-ce";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2016.2.2";
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "08x2x6lhr9100lmw1dq8rkz4mlyj4avcj2hpbd5qqybx9j4g6g44";
    };
    wmClass = "jetbrains-pycharm";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2016.2.1";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0vgr0ds6z0y8qw2v55nr3pi5zb5x0n6pxm13hcp44iradns5kmbp";
    };
    wmClass = "jetbrains-phpstorm";
  };

  phpstorm10 = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "10.0.4";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0fi042zvjpg5pn2mnhj3bbrdkl1b9vmhpf2l6ca4nr0rhjjv7dsm";
    };
    wmClass = "jetbrains-phpstorm";
  };

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "2016.2.2";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "0n2fvhjasklshyfcbwwn6wahzld8x65bid08245awdqv33p87bq6";
    };
    wmClass = "jetbrains-webstorm";
  };

  webstorm10 = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "10.0.5";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "0a5s6f99wyql5pgjl94pf4ljdbviik3b8dbr1s6b7c6jn1gk62ic";
    };
    wmClass = "jetbrains-webstorm";
  };

  webstorm11 = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "11.0.4";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "17agyqdyz6naxyx6p0y240ar93gja0ypw01nm2qmfzvh7ch03r24";
    };
    wmClass = "jetbrains-webstorm";
  };
}

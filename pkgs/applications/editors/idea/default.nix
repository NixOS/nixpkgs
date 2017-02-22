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

  buildDataGrip = { name, version, src, license, description, wmClass }:
    (mkIdeaProduct {
      inherit name version src wmClass jdk;
      product = "DataGrip";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/datagrip/";
        inherit description license;
        longDescription = ''
          DataGrip is a new IDE from JetBrains built for database admins.
          It allows you to quickly migrate and refactor relational databases,
          construct efficient, statically checked SQL queries and much more.
        '';
        maintainers = with maintainers; [ loskutov ];
        platforms = platforms.linux;
      };
    });
in

{
  clion = buildClion rec {
    name = "clion-${version}";
    version = "2016.3.3";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "1zziyg0y51lfybflq83qwd94wcypkv4gh0cdkwfybbk4yidpnz05";
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
    version = "2016.3.4";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "712dccd726b43e2187e8025a6effb711d35310b36d553dbf7bf85400ec1cec15";
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
    version = "2016.3.4";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "1ichjrdmnhyqv9cr73d8kif9l53k3x36i8js8nf9cmkbhdsfckn3";
    };
    wmClass = "jetbrains-idea";
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "2016.3.2";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "1fqlrvhlk09z8nx68qv4nqs5n8ldia3lixsl6r04gsfyl1a69sb6";
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
    version = "2016.3.2";
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "0fag5ng9n953mnf3gmxpac1icnb1qz6dybhqwjbr13qij8v2s2g1";
    };
    wmClass = "jetbrains-pycharm-ce";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2016.3.2";
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1nylq0fyvix68l4dp9852dak58dbiamjphx2hin087cadaji6r63";
    };
    wmClass = "jetbrains-pycharm";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2016.3.2";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "05ylhpn1mijjphcmv6ay3123xp72yypw19430dgr8101zpsnifa5";
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
    version = "2016.3.3";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "08f266afi8ia5jvvgk2lncra2n3i0l5c3h7c8fwxz6y8fhhlas4y";
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

  datagrip = buildDataGrip rec {
    name = "datagrip-${version}";
    version = "2016.3.2";
    description = "Your Swiss Army Knife for Databases and SQL";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/datagrip/${name}.tar.gz";
      sha256 = "19njb6i7nl6szql7cy99jmig59b304c6im3988p1dd8dj2j6csv3";
    };
    wmClass = "jetbrains-datagrip";
  };
}

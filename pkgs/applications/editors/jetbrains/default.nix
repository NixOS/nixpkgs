{ lib, stdenv, callPackage, fetchurl, makeDesktopItem, makeWrapper, patchelf
, coreutils, gnugrep, which, git, python, unzip, p7zip
, androidsdk, jdk
}:

assert stdenv.isLinux;

let
  mkJetBrainsProduct = callPackage ./common.nix { };

  # Sorted alphabetically

  buildClion = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
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

  buildDataGrip = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
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

  buildGogland = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "Gogland";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/go/";
        inherit description license;
        longDescription = ''
          Gogland is the codename for a new commercial IDE by JetBrains
          aimed at providing an ergonomic environment for Go development.
          The new IDE extends the IntelliJ platform with the coding assistance
          and tool integrations specific for the Go language
        '';
        maintainers = [ maintainers.miltador ];
        platforms = platforms.linux;
      };
    });

  buildIdea = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
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

  buildPhpStorm = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
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

  buildPycharm = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
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

  buildRider = { name, version, src, license, description, wmClass }:
    lib.overrideDerivation (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "Rider";
      meta = with stdenv.lib; {
        homepage = "https://www.jetbrains.com/rider/";
        inherit description license;
        longDescription = ''
          JetBrains Rider is a new .NET IDE based on the IntelliJ
          platform and ReSharper. Rider supports .NET Core,
          .NET Framework and Mono based projects. This lets you
          develop a wide array of applications including .NET desktop
          apps, services and libraries, Unity games, ASP.NET and
          ASP.NET Core web applications.
        '';
        maintainers = [ maintainers.miltador ];
        platforms = platforms.linux;
      };
    }) (attrs: {
      patchPhase = attrs.patchPhase + ''
        # Patch built-in mono for ReSharperHost to start successfully
        interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
        patchelf --set-interpreter "$interpreter" lib/ReSharperHost/linux-x64/mono/bin/mono-sgen
      '';
    });

  buildRubyMine = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct rec {
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

  buildWebStorm = { name, version, src, license, description, wmClass }:
    (mkJetBrainsProduct {
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

in

{
  # Sorted alphabetically

  clion = buildClion rec {
    name = "clion-${version}";
    version = "2017.1.1";
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "1bh92gakxqrg65rfhg8984ca338ff0y17kdjkpr6rbh1i39npgcs";
    };
    wmClass = "jetbrains-clion";
  };

  datagrip = buildDataGrip rec {
    name = "datagrip-${version}";
    version = "2017.1";
    description = "Your Swiss Army Knife for Databases and SQL";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/datagrip/${name}.tar.gz";
      sha256 = "91ee6a1e43d75a45ae51829835e457da85262410d89e617324d0239ba5625dfa";
    };
    wmClass = "jetbrains-datagrip";
  };

  gogland = buildGogland rec {
    name = "gogland-${version}";
    version = "171.4424.55";
    description = "Up and Coming Go IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/go/${name}.tar.gz";
      sha256 = "0l5pn2wj541v1xc58bpipkl483zrhwjr37grkwiwx2j4iygrikq7";
    };
    wmClass = "jetbrains-gogland";
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
    version = "2017.1.3";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "0ag70z4cark69hzhvx5j75qa8dglwzfaqrzi8pim3asd161fwxrx";
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
    version = "2017.1.3";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jdk.tar.gz";
      sha256 = "1gl62zrs3yxakgwbm29bv9z68jgy5ixc28zcagydx2h4j2b1fb19";
    };
    wmClass = "jetbrains-idea";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2017.1";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "1ynffm5x8fqq2r71rr9rbvdifbwbvbhqb2x1hkyy4az38gxal1bm";
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

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "2017.1.3";
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "06sai589zli5xaggfk4g0j0grbw9mya9qlwabmxh9414qq3bzvbd";
    };
    wmClass = "jetbrains-pycharm-ce";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2017.1.3";
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1wzgh83504px7q93h9xkarih2qjchiavgysy4di82q7377s6xd0c";
    };
    wmClass = "jetbrains-pycharm";
  };

  rider = buildRider rec {
    name = "rider-${version}";
    version = "171.3655.1246";
    description = "A cross-platform .NET IDE based on the IntelliJ platform and ReSharper";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/resharper/riderRS-${version}.tar.gz";
      sha256 = "90f9f8f1919e0f1dad42387f1a308483448323b089c13c409f3dd4d52992266b";
    };
    wmClass = "jetbrains-rider";
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "2017.1";
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "6c27f43ddc385ffba2cb2f011b80ab46d9b128d0fccf3b4ea43272fe36401a3a";
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

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "2017.1.3";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "0g4b0x910231ljdj18lnj2mlzmzyl12lv3fsbsz6v45i1kwpwnvc";
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

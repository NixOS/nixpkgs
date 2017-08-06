{ lib, stdenv, callPackage, fetchurl, makeDesktopItem, makeWrapper, patchelf
, coreutils, gnugrep, which, git, python, unzip, p7zip
, androidsdk, jdk, cmake, libxml2, zlib, python2, ncurses
}:

assert stdenv.isLinux;

with stdenv.lib;

let
  mkJetBrainsProduct = callPackage ./common.nix { };

  # Sorted alphabetically

  buildClion = { name, version, src, license, description, wmClass, update-channel }:
    lib.overrideDerivation (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "CLion";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/clion/;
        inherit description license;
        longDescription = ''
          Enhancing productivity for every C and C++
          developer on Linux, OS X and Windows.
        '';
        maintainers = with maintainers; [ edwtjo mic92 ];
        platforms = platforms.linux;
      };
    }) (attrs: {
      postFixup = (attrs.postFixup or "") + optionalString (stdenv.isLinux) ''
        (
          cd $out/clion-${version}
          # bundled cmake does not find libc
          rm -rf bin/cmake
          ln -s ${cmake} bin/cmake

          lldbLibPath=$out/clion-${version}/bin/lldb/lib
          interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
          ln -s ${ncurses.out}/lib/libncurses.so $lldbLibPath/libtinfo.so.5

          patchelf --set-interpreter $interp \
            --set-rpath "${lib.makeLibraryPath [ libxml2 zlib stdenv.cc.cc.lib ]}:$lldbLibPath" \
            bin/lldb/bin/lldb-server
          patchelf --set-interpreter $interp \
            --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}:$lldbLibPath" \
            bin/lldb/LLDBFrontend
          patchelf \
            --set-rpath "${lib.makeLibraryPath [ libxml2 zlib stdenv.cc.cc.lib python2 ]}:$lldbLibPath" \
            bin/lldb/lib/liblldb.so

          patchelf --set-interpreter $interp bin/gdb/bin/gdb
          patchelf --set-interpreter $interp bin/gdb/bin/gdbserver
          patchelf --set-interpreter $interp \
            --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib zlib ]}:$lldbLibPath" \
            bin/clang/clang-tidy
        )
      '';
    });

  buildDataGrip = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "DataGrip";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/datagrip/;
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

  buildGogland = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "Gogland";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/go/;
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

  buildIdea = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "IDEA";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/idea/;
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

  buildPhpStorm = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "PhpStorm";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/phpstorm/;
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

  buildPycharm = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "PyCharm";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/pycharm/;
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

  buildRider = { name, version, src, license, description, wmClass, update-channel }:
    lib.overrideDerivation (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "Rider";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/rider/;
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

  buildRubyMine = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "RubyMine";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/ruby/;
        inherit description license;
        longDescription = description;
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildWebStorm = { name, version, src, license, description, wmClass, update-channel }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "WebStorm";
      meta = with stdenv.lib; {
        homepage = https://www.jetbrains.com/webstorm/;
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
    version = "2017.2"; /* updated by script */
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "de7f47ec959be9653aa4d2028fb27f8327800d8370daa0ab2d1093f3469f4b49"; /* updated by script */
    };
    wmClass = "jetbrains-clion";
    update-channel = "CLion_Release"; # channel's id as in http://www.jetbrains.com/updates/updates.xml
  };

  datagrip = buildDataGrip rec {
    name = "datagrip-${version}";
    version = "2017.1.5"; /* updated by script */
    description = "Your Swiss Army Knife for Databases and SQL";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/datagrip/${name}.tar.gz";
      sha256 = "8847c35761fcf6fc7a1d3f2bed0fa3971fbf28721c144f41d21feb473bb212dc"; /* updated by script */
    };
    wmClass = "jetbrains-datagrip";
    update-channel = "datagrip_2017_1";
  };

  gogland = buildGogland rec {
    name = "gogland-${version}";
    version = "171.4694.61"; /* updated by script */
    description = "Up and Coming Go IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/go/${name}.tar.gz";
      sha256 = "8e9462fc7c5cc7dc110ea2257b920a55d7d52ea874a53567e5d19381a1fcb269"; /* updated by script */
    };
    wmClass = "jetbrains-gogland";
    update-channel = "gogland_1.0_EAP";
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
    update-channel = "IDEA14.1";
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2017.2.1";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1z8gp209jpjzvllnrpxzmbhgaxkklxw8nkm3g2drb7nal2hhs113";
    };
    wmClass = "jetbrains-idea-ce";
    update-channel = "IDEA_Release";
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
    update-channel = "IDEA14.1";
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
    update-channel = null;
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2017.1.5";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jdk.tar.gz";
      sha256 = "0gjj2g9fcrbbbp3v4clg0kj48qdw0gqcn9im4h8p3z2zscpg16ag";
    };
    wmClass = "jetbrains-idea";
    update-channel = "IDEA_Release";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2017.1.4";
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0zrbcziznz6dwh56snr27752xcsnl2gsxzi6jiraplkd92f2xlaf";
    };
    wmClass = "jetbrains-phpstorm";
    update-channel = "PS2017.1";
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
    update-channel = "WI10";
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "2017.1.5"; /* updated by script */
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1a0bbf0d881527e08aad7a5adaa3ad44e8754c3eb2c3a8ed5ab113491549679b"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm-ce";
    update-channel = "PyCharm_Release";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2017.1.5"; /* updated by script */
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "52519dfd0e913b5ccb8767155cd4d1fd413967d5010e8474cdc9a1fa688016ce"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm";
    update-channel = "PyCharm_Release";
  };

  rider = buildRider rec {
    name = "rider-${version}";
    version = "171.4456.1432"; /* updated by script */
    description = "A cross-platform .NET IDE based on the IntelliJ platform and ReSharper";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/resharper/Rider-RC-${version}.tar.gz";
      sha256 = "37bad69cdfcc4f297b2500a7bb673af7ef8f1fd45baa4eb2fa388d2c4bcb41ee"; /* updated by script */
    };
    wmClass = "jetbrains-rider";
    update-channel = "rider_2017_1_eap";
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "2017.1.5"; /* updated by script */
    description = "The Most Intelligent Ruby and Rails IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "198eb3d7914529ce3a6857e038167e194fb838c4b94242048ae45e8413458d66"; /* updated by script */
    };
    wmClass = "jetbrains-rubymine";
    update-channel = "rm2017.1";
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
    update-channel = null;
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
    update-channel = null;
  };

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "2017.1.4";
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "0aw2728wknss5vn2fkgz8rkm5vwk031305f32dirfrh51bvmq2zm";
    };
    wmClass = "jetbrains-webstorm";
    update-channel = "WS_Release";
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
    update-channel = null;
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
    update-channel = null;
  };
}

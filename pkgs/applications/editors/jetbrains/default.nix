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
          developer on Linux, macOS and Windows.
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

          wrapProgram $out/bin/clion \
            --set CL_JDK "${jdk}"
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
    lib.overrideDerivation (mkJetBrainsProduct {
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
    }) (attrs: {
      postFixup = (attrs.postFixup or "") + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp $out/gogland*/plugins/intellij-go-plugin/lib/dlv/linux/dlv

        chmod +x $out/gogland*/plugins/intellij-go-plugin/lib/dlv/linux/dlv
      '';
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
    version = "2017.2.3"; /* updated by script */
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "02hyndyfcrvfbi4q8vmmj0xh2bggwc2azggm24g3m03iffa7j6fx"; /* updated by script */
    };
    wmClass = "jetbrains-clion";
    update-channel = "CLion_Release"; # channel's id as in http://www.jetbrains.com/updates/updates.xml
  };

  datagrip = buildDataGrip rec {
    name = "datagrip-${version}";
    version = "2017.2.2"; /* updated by script */
    description = "Your Swiss Army Knife for Databases and SQL";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/datagrip/${name}.tar.gz";
      sha256 = "1l8y65fw9g5ckzwpcgigm2qwy8fhpw2hil576rphsnx6qvnh4swn"; /* updated by script */
    };
    wmClass = "jetbrains-datagrip";
    update-channel = "datagrip_2017_2";
  };

  gogland = buildGogland rec {
    name = "gogland-${version}";
    version = "173.2696.28"; /* updated by script */
    description = "Up and Coming Go IDE";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/go/${name}.tar.gz";
      sha256 = "07nz2pf7fnjxsvc82vihk2i880cji349czxzshr1dk50ixlydq7n"; /* updated by script */
    };
    wmClass = "jetbrains-gogland";
    update-channel = "gogland_1.0_EAP";
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2017.2.5"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "01p63wsy60icy4673ci435rmzpjfkyz7a8w413vw45i2bm76skhr"; /* updated by script */
    };
    wmClass = "jetbrains-idea-ce";
    update-channel = "IDEA_Release";
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2017.2.5"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jdk.tar.gz";
      sha256 = "0pp49nck1cad6pz81bd95v4v55vmnvj7cbdzybmldglka1afqjb6"; /* updated by script */
    };
    wmClass = "jetbrains-idea";
    update-channel = "IDEA_Release";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2017.2.4"; /* updated by script */
    description = "Professional IDE for Web and PHP developers";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "0hn3x5wid2z7s2mhnxfqh2yhdkscccpbz7qgsxkjvmkxcynazrvy"; /* updated by script */
    };
    wmClass = "jetbrains-phpstorm";
    update-channel = "PS2017.2";
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "2017.2.3"; /* updated by script */
    description = "PyCharm Community Edition";
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "1aik3jhggxfxnfv4kg9716gwsi013511jf9n20f2mqzdq8w2jmp8"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm-ce";
    update-channel = "PyCharm_Release";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2017.2.3"; /* updated by script */
    description = "PyCharm Professional Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "0ib96yaj7l0igiv2bcrqqpbfn2xn3ic7lxyjn99k6dh8ika1qvry"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm";
    update-channel = "PyCharm_Release";
  };

  rider = buildRider rec {
    name = "rider-${version}";
    version = "2017.1.2"; /* updated by script */
    description = "A cross-platform .NET IDE based on the IntelliJ platform and ReSharper";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/resharper/JetBrains.Rider-${version}.tar.gz";
      sha256 = "0kphjxibrs4ss6hpxbssvs3n35xh9zzw7a1q09x79ibvvk73gwqh"; /* updated by script */
    };
    wmClass = "jetbrains-rider";
    update-channel = "rider_2017_1";
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

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "2017.2.4"; /* updated by script */
    description = "Professional IDE for Web and JavaScript development";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "1dd2fbsyra4fm39w1kz2biljbrmcqwd866hvzsidigmjplhlzan0"; /* updated by script */
    };
    wmClass = "jetbrains-webstorm";
    update-channel = "WS_Release";
  };

}

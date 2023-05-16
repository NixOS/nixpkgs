<<<<<<< HEAD
{ lib
, stdenv
, callPackage
, fetchurl
, jdk
, cmake
, gdb
, zlib
, python3
, icu
, lldb
, dotnet-sdk_7
=======
{ lib, stdenv, callPackage, fetchurl
, jdk, cmake, gdb, zlib, python3, icu
, lldb
, dotnet-sdk_6
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, maven
, autoPatchelfHook
, libdbusmenu
, patchelf
, openssl
, expat
, libxcrypt-legacy
, vmopts ? null
}:

let
  platforms = lib.platforms.linux ++ [ "x86_64-darwin" "aarch64-darwin" ];
  ideaPlatforms = [ "x86_64-darwin" "i686-darwin" "i686-linux" "x86_64-linux" "aarch64-darwin" ];

  inherit (stdenv.hostPlatform) system;

  versions = builtins.fromJSON (lib.readFile (./versions.json));
  versionKey = if stdenv.isLinux then "linux" else system;
  products = versions.${versionKey} or (throw "Unsupported system: ${system}");

  package = if stdenv.isDarwin then ./darwin.nix else ./linux.nix;
  mkJetBrainsProduct = callPackage package { inherit vmopts; };

  # Sorted alphabetically

<<<<<<< HEAD
  buildClion = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
=======
  buildClion = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      product = "CLion";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/clion/";
        inherit description license platforms;
        longDescription = ''
          Enhancing productivity for every C and C++
          developer on Linux, macOS and Windows.
        '';
<<<<<<< HEAD
        maintainers = with maintainers; [ edwtjo mic92 tymscar ];
      };
    }).overrideAttrs (attrs: {
      nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ lib.optionals (stdenv.isLinux) [
        autoPatchelfHook
      ];
      buildInputs = (attrs.buildInputs or [ ]) ++ lib.optionals (stdenv.isLinux) [
=======
        maintainers = with maintainers; [ edwtjo mic92 ];
      };
    }).overrideAttrs (attrs: {
      nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ lib.optionals (stdenv.isLinux) [
        autoPatchelfHook
        patchelf
      ];
      buildInputs = (attrs.buildInputs or []) ++ lib.optionals (stdenv.isLinux) [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        python3
        stdenv.cc.cc
        libdbusmenu
        openssl.out
        expat
        libxcrypt-legacy
      ];
      dontAutoPatchelf = true;
      postFixup = (attrs.postFixup or "") + lib.optionalString (stdenv.isLinux) ''
        (
          cd $out/clion
<<<<<<< HEAD

          # I think the included gdb has a couple of patches, so we patch it instead of replacing
          ls -d $PWD/bin/gdb/linux/x64/lib/python3.8/lib-dynload/* |
          xargs patchelf \
            --replace-needed libssl.so.10 libssl.so \
            --replace-needed libcrypto.so.10 libcrypto.so
=======
          # bundled cmake does not find libc
          rm -rf bin/cmake/linux
          ln -s ${cmake} bin/cmake/linux
          # bundled gdb does not find libcrypto 10
          rm -rf bin/gdb/linux
          ln -s ${gdb} bin/gdb/linux
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

          ls -d $PWD/bin/lldb/linux/x64/lib/python3.8/lib-dynload/* |
          xargs patchelf \
            --replace-needed libssl.so.10 libssl.so \
            --replace-needed libcrypto.so.10 libcrypto.so

          autoPatchelf $PWD/bin
<<<<<<< HEAD
=======

          wrapProgram $out/bin/clion \
            --set CL_JDK "${jdk}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        )
      '';
    });

<<<<<<< HEAD
  buildDataGrip = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
=======
  buildDataGrip = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      product = "DataGrip";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/datagrip/";
        inherit description license platforms;
        longDescription = ''
          DataGrip is a new IDE from JetBrains built for database admins.
          It allows you to quickly migrate and refactor relational databases,
          construct efficient, statically checked SQL queries and much more.
        '';
        maintainers = with maintainers; [ ];
      };
    });

<<<<<<< HEAD
  buildDataSpell = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
      product = "DataSpell";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/dataspell/";
        inherit description license platforms;
        longDescription = ''
          DataSpell is a new IDE from JetBrains built for Data Scientists.
          Mainly it integrates Jupyter notebooks in the IntelliJ platform.
        '';
        maintainers = with maintainers; [ leona ];
      };
    });

  buildGateway = { pname, version, src, license, description, wmClass, buildNumber, product, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber product;
=======
  buildGateway = { pname, version, src, license, description, wmClass, product, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk product;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      productShort = "Gateway";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/remote-development/gateway/";
        inherit description license platforms;
        longDescription = ''
          JetBrains Gateway is a lightweight launcher that connects a remote
          server with your local machine, downloads necessary components on the
          backend, and opens your project in JetBrains Client.
        '';
        maintainers = with maintainers; [ kouyk ];
      };
    });

<<<<<<< HEAD
  buildGoland = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
      product = "Goland";
      extraWrapperArgs = [
        # fortify source breaks build since delve compiles with -O0
        ''--prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"''
      ];
=======
  buildGoland = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
      product = "Goland";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      meta = with lib; {
        homepage = "https://www.jetbrains.com/go/";
        inherit description license platforms;
        longDescription = ''
          Goland is the codename for a new commercial IDE by JetBrains
          aimed at providing an ergonomic environment for Go development.
          The new IDE extends the IntelliJ platform with the coding assistance
          and tool integrations specific for the Go language
        '';
<<<<<<< HEAD
        maintainers = with maintainers; [ tymscar ];
=======
        maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }).overrideAttrs (attrs: {
      postFixup = (attrs.postFixup or "") + lib.optionalString stdenv.isLinux ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
<<<<<<< HEAD
        chmod +x $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
      '';
    });

  buildIdea = { pname, version, src, license, description, wmClass, buildNumber, product, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber product;
=======

        chmod +x $out/goland/plugins/go-plugin/lib/dlv/linux/dlv

        # fortify source breaks build since delve compiles with -O0
        wrapProgram $out/bin/goland \
          --prefix CGO_CPPFLAGS " " "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"
      '';
    });

  buildIdea = { pname, version, src, license, description, wmClass, product, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk product;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      productShort = "IDEA";
      extraLdPath = [ zlib ];
      extraWrapperArgs = [
        ''--set M2_HOME "${maven}/maven"''
        ''--set M2 "${maven}/maven/bin"''
      ];
      meta = with lib; {
        homepage = "https://www.jetbrains.com/idea/";
        inherit description license;
        longDescription = ''
          IDE for Java SE, Groovy & Scala development Powerful
          environment for building Google Android apps Integration
          with JUnit, TestNG, popular SCMs, Ant & Maven. Also known
          as IntelliJ.
        '';
<<<<<<< HEAD
        maintainers = with maintainers; [ edwtjo gytis-ivaskevicius steinybot AnatolyPopov tymscar ];
=======
        maintainers = with maintainers; [ edwtjo gytis-ivaskevicius steinybot AnatolyPopov ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        platforms = ideaPlatforms;
      };
    });

<<<<<<< HEAD
  buildMps = { pname, version, src, license, description, wmClass, product, buildNumber, ... }:
    (mkJetBrainsProduct rec {
      inherit pname version src wmClass jdk buildNumber product;
=======
  buildMps = { pname, version, src, license, description, wmClass, product, ... }:
    (mkJetBrainsProduct rec {
      inherit pname version src wmClass jdk product;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      productShort = "MPS";
      meta = with lib; {
        broken = (stdenv.isLinux && stdenv.isAarch64);
        homepage = "https://www.jetbrains.com/mps/";
        inherit license description platforms;
        longDescription = ''
          A metaprogramming system which uses projectional editing
          which allows users to overcome the limits of language
          parsers, and build DSL editors, such as ones with tables and
          diagrams.
        '';
        maintainers = with maintainers; [ rasendubi ];
      };
    });

<<<<<<< HEAD
  buildPhpStorm = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
=======
  buildPhpStorm = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      product = "PhpStorm";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/phpstorm/";
        inherit description license platforms;
        longDescription = ''
          PhpStorm provides an editor for PHP, HTML and JavaScript
          with on-the-fly code analysis, error prevention and
          automated refactorings for PHP and JavaScript code.
        '';
<<<<<<< HEAD
        maintainers = with maintainers; [ dritter tymscar ];
      };
    });

  buildPycharm = { pname, version, src, license, description, wmClass, buildNumber, product, cythonSpeedup ? stdenv.isLinux, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber product;
=======
        maintainers = with maintainers; [ dritter ];
      };
    });

  buildPycharm = { pname, version, src, license, description, wmClass, product, cythonSpeedup ? stdenv.isLinux, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk product;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      productShort = "PyCharm";
      meta = with lib; {
        broken = (stdenv.isLinux && stdenv.isAarch64);
        homepage = "https://www.jetbrains.com/pycharm/";
        inherit description license platforms;
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
<<<<<<< HEAD
        maintainers = with maintainers; [ genericnerdyusername tymscar ];
=======
        maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }).overrideAttrs (finalAttrs: previousAttrs: lib.optionalAttrs cythonSpeedup {
      buildInputs = with python3.pkgs; [ python3 setuptools ];
      preInstall = ''
<<<<<<< HEAD
        echo "compiling cython debug speedups"
        if [[ -d plugins/python-ce ]]; then
            ${python3.interpreter} plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
        else
            ${python3.interpreter} plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
        fi
=======
      echo "compiling cython debug speedups"
      if [[ -d plugins/python-ce ]]; then
          ${python3.interpreter} plugins/python-ce/helpers/pydev/setup_cython.py build_ext --inplace
      else
          ${python3.interpreter} plugins/python/helpers/pydev/setup_cython.py build_ext --inplace
      fi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      '';
      # See https://www.jetbrains.com/help/pycharm/2022.1/cython-speedups.html
    });

<<<<<<< HEAD
  buildRider = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
=======
  buildRider = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      product = "Rider";
      # icu is required by Rider.Backend
      extraLdPath = [ icu ];
      meta = with lib; {
        homepage = "https://www.jetbrains.com/rider/";
        inherit description license platforms;
        longDescription = ''
          JetBrains Rider is a new .NET IDE based on the IntelliJ
          platform and ReSharper. Rider supports .NET Core,
          .NET Framework and Mono based projects. This lets you
          develop a wide array of applications including .NET desktop
          apps, services and libraries, Unity games, ASP.NET and
          ASP.NET Core web applications.
        '';
        maintainers = with maintainers; [ raphaelr ];
      };
    }).overrideAttrs (attrs: {
      postPatch = lib.optionalString (!stdenv.isDarwin) (attrs.postPatch + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp \
          lib/ReSharperHost/linux-x64/Rider.Backend \
          plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer

        rm -rf lib/ReSharperHost/linux-x64/dotnet
<<<<<<< HEAD
        ln -s ${dotnet-sdk_7} lib/ReSharperHost/linux-x64/dotnet
      '');
    });

  buildRubyMine = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
=======
        ln -s ${dotnet-sdk_6} lib/ReSharperHost/linux-x64/dotnet
      '');
    });

  buildRubyMine = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      product = "RubyMine";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/ruby/";
        inherit description license platforms;
        longDescription = description;
<<<<<<< HEAD
        maintainers = with maintainers; [ edwtjo tymscar ];
      };
    });

  buildWebStorm = { pname, version, src, license, description, wmClass, buildNumber, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk buildNumber;
=======
        maintainers = with maintainers; [ edwtjo ];
      };
    });

  buildWebStorm = { pname, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit pname version src wmClass jdk;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      product = "WebStorm";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/webstorm/";
        inherit description license platforms;
        longDescription = ''
          WebStorm provides an editor for HTML, JavaScript (incl. Node.js),
          and CSS with on-the-fly code analysis, error prevention and
          automated refactorings for JavaScript code.
        '';
<<<<<<< HEAD
        maintainers = with maintainers; [ abaldeau tymscar ];
=======
        maintainers = with maintainers; [ abaldeau ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    });

in

{
  # Sorted alphabetically

  clion = buildClion rec {
    pname = "clion";
    version = products.clion.version;
<<<<<<< HEAD
    buildNumber = products.clion.build_number;
    description = "C/C++ IDE. New. Intelligent. Cross-platform";
=======
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.clion.url;
      sha256 = products.clion.sha256;
    };
    wmClass = "jetbrains-clion";
    update-channel = products.clion.update-channel;
  };

  datagrip = buildDataGrip rec {
    pname = "datagrip";
    version = products.datagrip.version;
<<<<<<< HEAD
    buildNumber = products.datagrip.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Your Swiss Army Knife for Databases and SQL";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.datagrip.url;
      sha256 = products.datagrip.sha256;
    };
    wmClass = "jetbrains-datagrip";
    update-channel = products.datagrip.update-channel;
  };

<<<<<<< HEAD
  dataspell = buildDataSpell rec {
    pname = "dataspell";
    version = products.dataspell.version;
    buildNumber = products.dataspell.build_number;
    description = "The IDE for Professional Data Scientists";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.dataspell.url;
      sha256 = products.dataspell.sha256;
    };
    wmClass = "jetbrains-dataspell";
    update-channel = products.dataspell.update-channel;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  gateway = buildGateway rec {
    pname = "gateway";
    product = "JetBrains Gateway";
    version = products.gateway.version;
<<<<<<< HEAD
    buildNumber = products.gateway.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Your single entry point to all remote development environments";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.gateway.url;
      sha256 = products.gateway.sha256;
    };
    wmClass = "jetbrains-gateway";
    update-channel = products.gateway.update-channel;
  };

  goland = buildGoland rec {
    pname = "goland";
    version = products.goland.version;
<<<<<<< HEAD
    buildNumber = products.goland.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Up and Coming Go IDE";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.goland.url;
      sha256 = products.goland.sha256;
    };
    wmClass = "jetbrains-goland";
    update-channel = products.goland.update-channel;
  };

  idea-community = buildIdea rec {
    pname = "idea-community";
    product = "IntelliJ IDEA CE";
    version = products.idea-community.version;
<<<<<<< HEAD
    buildNumber = products.idea-community.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = products.idea-community.url;
      sha256 = products.idea-community.sha256;
    };
    wmClass = "jetbrains-idea-ce";
    update-channel = products.idea-community.update-channel;
  };

  idea-ultimate = buildIdea rec {
    pname = "idea-ultimate";
    product = "IntelliJ IDEA";
    version = products.idea-ultimate.version;
<<<<<<< HEAD
    buildNumber = products.idea-ultimate.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.idea-ultimate.url;
      sha256 = products.idea-ultimate.sha256;
    };
    wmClass = "jetbrains-idea";
    update-channel = products.idea-ultimate.update-channel;
  };

  mps = buildMps rec {
    pname = "mps";
    product = "MPS ${products.mps.version}";
    version = products.mps.version;
<<<<<<< HEAD
    buildNumber = products.mps.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Create your own domain-specific language";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = products.mps.url;
      sha256 = products.mps.sha256;
    };
    wmClass = "jetbrains-mps";
    update-channel = products.mps.update-channel;
  };

  phpstorm = buildPhpStorm rec {
    pname = "phpstorm";
    version = products.phpstorm.version;
<<<<<<< HEAD
    buildNumber = products.phpstorm.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Professional IDE for Web and PHP developers";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.phpstorm.url;
      sha256 = products.phpstorm.sha256;
    };
    wmClass = "jetbrains-phpstorm";
    update-channel = products.phpstorm.update-channel;
  };

  pycharm-community = buildPycharm rec {
    pname = "pycharm-community";
    product = "PyCharm CE";
    version = products.pycharm-community.version;
<<<<<<< HEAD
    buildNumber = products.pycharm-community.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "PyCharm Community Edition";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = products.pycharm-community.url;
      sha256 = products.pycharm-community.sha256;
    };
    wmClass = "jetbrains-pycharm-ce";
    update-channel = products.pycharm-community.update-channel;
  };

  pycharm-professional = buildPycharm rec {
    pname = "pycharm-professional";
    product = "PyCharm";
    version = products.pycharm-professional.version;
<<<<<<< HEAD
    buildNumber = products.pycharm-community.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "PyCharm Professional Edition";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.pycharm-professional.url;
      sha256 = products.pycharm-professional.sha256;
    };
    wmClass = "jetbrains-pycharm";
    update-channel = products.pycharm-professional.update-channel;
  };

  rider = buildRider rec {
    pname = "rider";
    version = products.rider.version;
<<<<<<< HEAD
    buildNumber = products.rider.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A cross-platform .NET IDE based on the IntelliJ platform and ReSharper";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.rider.url;
      sha256 = products.rider.sha256;
    };
    wmClass = "jetbrains-rider";
    update-channel = products.rider.update-channel;
  };

  ruby-mine = buildRubyMine rec {
    pname = "ruby-mine";
    version = products.ruby-mine.version;
<<<<<<< HEAD
    buildNumber = products.ruby-mine.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "The Most Intelligent Ruby and Rails IDE";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.ruby-mine.url;
      sha256 = products.ruby-mine.sha256;
    };
    wmClass = "jetbrains-rubymine";
    update-channel = products.ruby-mine.update-channel;
  };

  webstorm = buildWebStorm rec {
    pname = "webstorm";
    version = products.webstorm.version;
<<<<<<< HEAD
    buildNumber = products.webstorm.build_number;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Professional IDE for Web and JavaScript development";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = products.webstorm.url;
      sha256 = products.webstorm.sha256;
    };
    wmClass = "jetbrains-webstorm";
    update-channel = products.webstorm.update-channel;
  };

<<<<<<< HEAD
  plugins = callPackage ./plugins { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}

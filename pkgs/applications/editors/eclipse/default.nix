{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  freetype,
  fontconfig,
  libX11,
  libXrender,
  zlib,
  glib,
  gtk3,
  gtk2,
  libXtst,
  jdk,
  jdk8,
  gsettings-desktop-schemas,
  webkitgtk ? null, # for internal web browser
  buildEnv,
  runCommand,
  callPackage,
}:

# use ./update.sh to help with updating for each quarterly release
#
# then, to test:
# for e in cpp dsl embedcpp modeling platform sdk java jee committers rcp; do for s in pkgs pkgsCross.aarch64-multiplatform; do echo; echo $s $e; nix-build -A ${s}.eclipses.eclipse-${e} -o eclipse-${s}-${e}; done; done

let
  platform_major = "4";
  platform_minor = "31";
  year = "2024";
  month = "03"; # release month
  buildmonth = "02"; # sometimes differs from release month
  timestamp = "${year}${buildmonth}290520";
  gtk = gtk3;
  arch =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else
      throw "don't know what platform suffix for ${stdenv.hostPlatform.system} will be";
in
rec {

  # work around https://bugs.eclipse.org/bugs/show_bug.cgi?id=476075#c3
  buildEclipseUnversioned = callPackage ./build-eclipse.nix {
    inherit
      stdenv
      makeDesktopItem
      freetype
      fontconfig
      libX11
      libXrender
      zlib
      jdk
      glib
      gtk
      libXtst
      gsettings-desktop-schemas
      webkitgtk
      makeWrapper
      ;
  };
  buildEclipse =
    eclipseData:
    buildEclipseUnversioned (
      eclipseData // { productVersion = "${platform_major}.${platform_minor}"; }
    );

  ### Eclipse CPP

  eclipse-cpp = buildEclipse {
    name = "eclipse-cpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for C/C++ Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-cpp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-lZtU/IUNx2tc6TwCFQ5WS7cO/Gui2JpeknnL+Z/mBow=";
          aarch64 = "sha256-iIUOiFp0uLOzwdqBV1txRhliaE2l1kbhGv1F6h0WO+w=";
        }
        .${arch};
    };
  };

  ### Eclipse DSL

  eclipse-dsl = buildEclipse {
    name = "eclipse-dsl-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java and DSL Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-dsl-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-gdtDI9A+sUDAFsyqEmXuIkqgd/v1WF+Euj0TSWwjeL4=";
          aarch64 = "sha256-kYa+8E5KLqHdumBQiIom3eG5rM/9TFZlJyyc7HpySes=";
        }
        .${arch};
    };
  };

  ### Eclipse IDE for Embedded C/C++ Developers

  eclipse-embedcpp = buildEclipse {
    name = "eclipse-embedcpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Embedded C/C++ Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-embedcpp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-5g4CAX2mu1i6aMqmbgy4R3Npk1IC/W73FrIZAQwgGCc=";
          aarch64 = "sha256-KcfybNDyGglULKF3HF5v50mBs69FFryCMZ+oBtjBFiw=";
        }
        .${arch};
    };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-yRJWSEg0TVWpgQBSS+y8/YrjdU3PSvJoruEUwjZcrLc=";
          aarch64 = "sha256-Czm8nYAkVqS8gaowDp1LrJ31iE32d6klT6JvHekL52c=";
        }
        .${arch};
    };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-PIvJeITqftd9eHhfbF+R+SQ+MXp4OmM5xi8ZDdUvXaI=";
          aarch64 = "sha256-C04AICPcb9foEai3Nk4S4zxQ3oUv+i2tckwqDscpx7I=";
        }
        .${arch};
    };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk =
    (buildEclipseUnversioned.override
      {
        jdk = jdk8;
        gtk = gtk2;
      }
      {
        name = "eclipse-scala-sdk-4.7.0";
        description = "Eclipse IDE for Scala Developers";
        productVersion = "4.7";
        src = fetchurl {
          url = "https://downloads.typesafe.com/scalaide-pack/4.7.0-vfinal-oxygen-212-20170929/scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz";
          sha256 = "1n5w2a7mh9ajv6fxcas1gpgwb04pdxbr9v5dzr67gsz5bhahq4ya";
        };
      }
    ).overrideAttrs
      (oa: {
        # Only download for x86_64
        meta.platforms = [ "x86_64-linux" ];
      });

  ### Eclipse SDK

  eclipse-sdk = buildEclipse {
    name = "eclipse-sdk-${platform_major}.${platform_minor}";
    description = "Eclipse ${year}-${month} Classic";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-SDK-${platform_major}.${platform_minor}-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-omsAZSlCvggTjoAPQt0oGqRUZwyt5H2LswGpFt88L+I=";
          aarch64 = "sha256-wcrYVlL5x+Wve2MAgnEFQ4H3a/gc2y8Fr5TmwHU9p6A=";
        }
        .${arch};
    };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-8WqHFLywYQXtzUGxBVstxGqVU55WHoApZnyZ6ur4XgU=";
          aarch64 = "sha256-GlD0ykJbwdbzh1K3XQQ79yBhCJQUlmt2v8c2OMYNWp4=";
        }
        .${arch};
    };
  };

  ### Eclipse Java EE

  eclipse-jee = buildEclipse {
    name = "eclipse-jee-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Enterprise Java and Web Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-jee-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-K2uo2VVL6rP9kxicJRLzsJiOFKloLD0vInSon8JsUWg=";
          aarch64 = "sha256-qeEQTlFeWBag6SLXoatDeviR/NG8EcTi6VyUo9P6STM=";
        }
        .${arch};
    };
  };

  ### Eclipse Committers

  eclipse-committers = buildEclipse {
    name = "eclipse-committers-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Eclipse Committers and Eclipse Platform Plugin Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-committers-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-Ko4NCU9jbkjAWY7Ky5tPlhXOnzkpY4GjPi6Z0CBmzzc=";
          aarch64 = "sha256-RBT+xwdQcJh+YgsuCPTWy9MM2y45bhIF9DttPm6Qz+Q=";
        }
        .${arch};
    };
  };

  ### Eclipse IDE for RCP and RAP Developers

  eclipse-rcp = buildEclipse {
    name = "eclipse-rcp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for RCP and RAP Developers";
    src = fetchurl {
      url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-rcp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
      hash =
        {
          x86_64 = "sha256-dWwDv8cfUxnU/24ASYLvSTbS3xV5ugG98jYMhAXTfS8=";
          aarch64 = "sha256-+bAKFZ4u5PvCdC4Ifj5inppWb6C8wh0tar66qryx76o=";
        }
        .${arch};
    };
  };

  ### Environments

  # Function that assembles a complete Eclipse environment from an
  # Eclipse package and list of Eclipse plugins.
  eclipseWithPlugins =
    {
      eclipse,
      plugins ? [ ],
      jvmArgs ? [ ],
    }:
    let
      # Gather up the desired plugins.
      pluginEnv = buildEnv {
        name = "eclipse-plugins";
        paths = with lib; filter (x: x ? isEclipsePlugin) (closePropagation plugins);
      };

      # Prepare the JVM arguments to add to the ini file. We here also
      # add the property indicating the plugin directory.
      dropinPropName = "org.eclipse.equinox.p2.reconciler.dropins.directory";
      dropinProp = "-D${dropinPropName}=${pluginEnv}/eclipse/dropins";
      jvmArgsText = lib.concatStringsSep "\n" (jvmArgs ++ [ dropinProp ]);

      # Base the derivation name on the name of the underlying
      # Eclipse.
      name = (lib.meta.appendToName "with-plugins" eclipse).name;
    in
    runCommand name { nativeBuildInputs = [ makeWrapper ]; } ''
      mkdir -p $out/bin $out/etc

      # Prepare an eclipse.ini with the plugin directory.
      cat ${eclipse}/eclipse/eclipse.ini - > $out/etc/eclipse.ini <<EOF
      ${jvmArgsText}
      EOF

      makeWrapper ${eclipse}/bin/eclipse $out/bin/eclipse \
        --add-flags "--launcher.ini $out/etc/eclipse.ini"

      ln -s ${eclipse}/share $out/
    '';

  ### Plugins

  plugins = callPackage ./plugins.nix { } // {
    __attrsFailEvaluation = true;
  };

}

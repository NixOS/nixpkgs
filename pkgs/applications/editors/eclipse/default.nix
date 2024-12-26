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
  webkitgtk_4_0 ? null, # for internal web browser
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
  platform_minor = "34";
  year = "2024";
  month = "12"; # release month
  buildmonth = "11"; # sometimes differs from release month
  timestamp = "${year}${buildmonth}201800";
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
      webkitgtk_4_0
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
          x86_64 = "sha256-d3MVeci4jF9adqvgepmZtzoPul+DTMtJlf7v92PMyq0=";
          aarch64 = "sha256-gsOmF3bGthd7CEG+HxEQJqACfb+ErWU+fVO2MVR2cz8=";
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
          x86_64 = "sha256-bJvODmesfkED5yHnaJGLZSeFctfVCQDA3lvH00S/zbk=";
          aarch64 = "sha256-e0rWjD19tUyVJMMbb5THVj28o0HnBFssP0yCAQ5wKnA=";
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
          x86_64 = "sha256-+DfoJ+QAlI9Ioz4Wbj2LvtpV3vAXjl0wtZBNS9osOYw=";
          aarch64 = "sha256-XCpIKoLhrodOJkLPY6uICpuYu5PBUp96MFQCeuOyOUA=";
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
          x86_64 = "sha256-MUe5DU+3/4lzG1hykpgOX/46Pgp9qtoN9MOYk6EFK6o=";
          aarch64 = "sha256-/tv7+RsRAFfV5zfU+uFNNlE1rrJavRFOhLYhSkIX0Ec=";
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
          x86_64 = "sha256-ZHJkIOAaz87z6Dz/6X62E7ckQIFDtzqgE5ODZeb/Rss=";
          aarch64 = "sha256-dLLwLFTeUXoL9Pri4EB48nZGUH/zF2mCt6anv519aP4=";
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
          x86_64 = "sha256-DhrNe9nx4RYAaq+NIHCBLX+bOn+dE13yF07hjuRzHZI=";
          aarch64 = "sha256-OHE0vxjV9kp43Os2LCLuZFCMLWy3vnCChMC54TyXO9I=";
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
          x86_64 = "sha256-z0hLFqdDSqhUmCiOp0fkTkiybOmCIA118JMBb90yEiY=";
          aarch64 = "sha256-JzUgyfPEi9vq497gJhHuobb0TR113hC2suFvNKix7So=";
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
          x86_64 = "sha256-PxQ+jGTEs917IeWuTCgyyx7vAodZr4ju/aa4WQmoGQ0=";
          aarch64 = "sha256-g4EHYFjoPONiGwreAmENcXWVinPkDAIE6KyVmZokQAo=";
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
          x86_64 = "sha256-g8ILZ9esbXbm+4bImFJkEwE/UNJT2HHCXx/8i+Lvb00=";
          aarch64 = "sha256-arV2VgQypj8fSEpqGd8CbJ/FyKE6k+e4x7kXqShDKrw=";
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
          x86_64 = "sha256-qqOdASLe11FT4Eot7j/Yf02acHgblV77W3fqTOCrNSQ=";
          aarch64 = "sha256-9yA2OLOcp3uKJ88OKqz7vCXMzS52om6ohUJkGZpkjE4=";
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
        paths = lib.filter (x: x ? isEclipsePlugin) (lib.closePropagation plugins);
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

  plugins = callPackage ./plugins.nix { };

}

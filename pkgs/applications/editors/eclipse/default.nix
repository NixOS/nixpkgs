{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, gtk2, libXtst, jdk, jdk8, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser
, buildEnv, runCommand
, callPackage



,fetchzip
}:

# https://download.eclipse.org/eclipse/downloads/ is the main place to
# find the downloads needed for new versions
#
# to test:
# $ for e in cpp modeling platform sdk java jee committers rcp; do nix build -f default.nix pkgs.eclipses.eclipse-${e} -o eclipse-${e}; done

let
  platform_major = "4";
  platform_minor = "23";
  year = "2022";
  month = "03"; #release month
  buildmonth = "03"; #sometimes differs from release month
  timestamp = "${year}${buildmonth}080310";
  gtk = gtk3;
in rec {

  # work around https://bugs.eclipse.org/bugs/show_bug.cgi?id=476075#c3
  buildEclipseUnversioned = callPackage ./build-eclipse.nix {
    inherit stdenv makeDesktopItem freetype fontconfig libX11 libXrender zlib
            jdk glib gtk libXtst gsettings-desktop-schemas webkitgtk
            makeWrapper;
  };
  buildEclipse = eclipseData: buildEclipseUnversioned (eclipseData // { productVersion = "${platform_major}.${platform_minor}"; });

  ### Eclipse CPP

  eclipse-cpp = buildEclipse {
    name = "eclipse-cpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-cpp-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        hash = "sha512-IKoHGBH8pQ1mkdMz11exO1u5T3hCPk662nPYoFunCyrQHOVA6KDAVHzEo1dxNUSJVGvW9YHDbGlZphXniTBJHw==";
      };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        hash = "sha512-cG3mMEJiuNrVfFy5nNkVqC2OpMeE5C1iu26E+LKGwwIBwqPoJtFBPRhLdGVC73KwDDRK8DEyurXsiFal60dv/g==";
      };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        hash = "sha512-AEGENE5AXXUmIRwv8Hp3LByfPtuG/HvipqkMoq+K4A+8Y7NZCRQM9YSf8zr42S0aYTr6rwP6VJajpFiz4ixULg==";
      };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk =
    buildEclipseUnversioned.override { jdk = jdk8; gtk = gtk2; } {
      name = "eclipse-scala-sdk-4.7.0";
      description = "Eclipse IDE for Scala Developers";
      productVersion = "4.7";
      src =
        fetchurl {
          url = "https://downloads.typesafe.com/scalaide-pack/4.7.0-vfinal-oxygen-212-20170929/scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz";
          sha256  = "1n5w2a7mh9ajv6fxcas1gpgwb04pdxbr9v5dzr67gsz5bhahq4ya";
        };
  };

  ### Eclipse SDK

  eclipse-sdk = buildEclipse {
    name = "eclipse-sdk-${platform_major}.${platform_minor}";
    description = "Eclipse ${year}-${month} Classic";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-SDK-${platform_major}.${platform_minor}-linux-gtk-x86_64.tar.gz";
        hash = "sha512-CTSuI6Dc2wKe0RduPKAacQmXbEBtF4J7Q5b9gC1MIkXXWPLW7Yp+lL/a167TXgDHG3kqNWbonjZ2JwU2T0FRjg==";
      };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        hash = "sha512-6QOtNFYCRhdSiclEwijBcp2EODnlp8qtO56NJLuRdgwpEe+3A567L/vsZe/E72YTGZOFh9yJ7+XehIEjonfUIw==";
      };
  };

  ### Eclipse Java EE

  eclipse-jee = buildEclipse {
    name = "eclipse-jee-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Enterprise Java and Web Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-jee-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        hash = "sha512-bgaRM7l4WOoGA8doR/nqjV4Hnszx3N4cZANYfq/Fq5Agspocu4m1F4ofetQC4BdlLkx0o+moKSN6sm34aT5H4Q==";
      };
  };

  ### Eclipse Committers

  eclipse-committers = buildEclipse {
    name = "eclipse-committers-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Eclipse Committers and Eclipse Platform Plugin Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-committers-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        hash = "sha512-YyyATAL0pJVrinrLixIW3p+bz3WfD7L/WL0EGnUWgCGsiVDzF2CGoXXT8YsH34uc+6Hn8z23JCoNX4Sqdo8i7Q==";
      };
  };

  ### Eclipse IDE for RCP and RAP Developers

  eclipse-rcp = buildEclipse {
    name = "eclipse-rcp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for RCP and RAP Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-rcp-${year}-${month}-R-linux-gtk-x86_64.tar.gz";
        hash = "sha256-1Go3e1HDRJlba8ySYRfi0+aU6aHjKmd3fc/IgeKw18c=";
      };
  };

  ### Environments

  # Function that assembles a complete Eclipse environment from an
  # Eclipse package and list of Eclipse plugins.
  eclipseWithPlugins = { eclipse, plugins, jvmArgs ? [] }:
    let
      p2Director = ''
        $out/bin/eclipse \
          -nosplash \
          -configuration /build/configuration \
          -application org.eclipse.equinox.p2.director \
      '';
      jvmArgsText = lib.strings.concatStrings (map (arg: "${arg}\n") jvmArgs);

      join = strings: lib.strings.concatStringsSep "," strings;
      pluginRepository = plugin:
        join (["file:${plugin.out}"] ++ (map pluginRepository plugin.dependencies));
      pluginInstallIU = plugin:
        # collect all installable units if none are provided
        if plugin ? installableUnits
        then join plugin.installableUnits
        else ''$(
          ${p2Director} \
            -repository '${pluginRepository plugin}' \
            -list \
            -listFormat '[''${id},]' \
            | awk -F'[][]' '{printf $2}'
        )'';
      repository = join (map pluginRepository plugins);
      installIU = join (map pluginInstallIU plugins);
    in
      eclipse.overrideAttrs (oldAttrs: {
        buildCommand = oldAttrs.buildCommand + ''
          ${p2Director} \
            -destination $out/eclipse \
            -repository "${repository}" \
            -installIU "${installIU}" \
            -tag AddIUs || {
              cat /build/configuration/*.log
              exit 1
            }
          cat << EOF >> $out/eclipse/eclipse.ini
          ${jvmArgsText}
          EOF
        '';
      });

  ### Plugins

  plugins = callPackage ./plugins.nix { };

}

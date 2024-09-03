{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, gtk2, libXtst, jdk, jdk8, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser
, buildEnv, runCommand
, callPackage
}:

# use ./update.sh to help with updating for each quarterly release
#
# then, to test:
# for e in cpp dsl embedcpp modeling platform sdk java jee committers rcp; do for s in pkgs pkgsCross.aarch64-multiplatform; do echo; echo $s $e; nix-build -A ${s}.eclipses.eclipse-${e} -o eclipse-${s}-${e}; done; done

let
  platform_major = "4";
  platform_minor = "32";
  year = "2024";
  month = "06"; #release month
  buildmonth = "06"; #sometimes differs from release month
  timestamp = "${year}${buildmonth}010610";
  gtk = gtk3;
  arch = if stdenv.hostPlatform.isx86_64 then
    "x86_64"
  else if stdenv.hostPlatform.isAarch64 then
    "aarch64"
  else throw "don't know what platform suffix for ${stdenv.hostPlatform.system} will be";
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
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-cpp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-yMyigXPd6BhSiyoLTFQhBrHnatgXMw1BrH7xWfoT0Zo=";
          aarch64 = "sha256-YZ1MhvXWcYRgQ4ZR/hXEWNKmYji/9PyKbdnm27i8Vjs=";
        }.${arch};
      };
  };

  ### Eclipse DSL

  eclipse-dsl = buildEclipse {
    name = "eclipse-dsl-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java and DSL Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-dsl-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-m2kcsQicvZcIHAP0zcOGYQjS4vdiTo62o1cfDpG4Ea8=";
          aarch64 = "sha256-UuMfIO6jgMpAmtGihWdJZ7RwilBVdsCaPJH3tKdwyLY=";
        }.${arch};
      };
  };

  ### Eclipse IDE for Embedded C/C++ Developers

  eclipse-embedcpp = buildEclipse {
    name = "eclipse-embedcpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Embedded C/C++ Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-embedcpp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-dpsdjBfF83B8wGwoIsT4QW/n4Qo/w+n4mNYtILdCJKw=";
          aarch64 = "sha256-kDPZJbrxEBhx/KI/9SqOtOOoMVWvYJqTLLgR9YPNH5A=";
        }.${arch};
      };
  };

  ### Eclipse Modeling

  eclipse-modeling = buildEclipse {
    name = "eclipse-modeling-${platform_major}.${platform_minor}";
    description = "Eclipse Modeling Tools";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-modeling-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-vANUS1IbYrhrpNX095XIhpaHlZhTkZe894nhrDPndJc=";
          aarch64 = "sha256-ykw9Og4D3hVfUvJlbtSDUB7iOmDJ9gPVTmpXlGZX304=";
        }.${arch};
      };
  };

  ### Eclipse Platform

  eclipse-platform = buildEclipse {
    name = "eclipse-platform-${platform_major}.${platform_minor}";
    description = "Eclipse Platform ${year}-${month}";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-platform-${platform_major}.${platform_minor}-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-ow4i9sDPQUAolzBymvucqpdZrn+bggxR6BD2RnyBVns=";
          aarch64 = "sha256-XZY7MQr1cCToIlEXSltxWRZbHu1Ex0wzLvL1nUhuKhw=";
        }.${arch};
      };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk =
    (buildEclipseUnversioned.override { jdk = jdk8; gtk = gtk2; } {
      name = "eclipse-scala-sdk-4.7.0";
      description = "Eclipse IDE for Scala Developers";
      productVersion = "4.7";
      src =
        fetchurl {
          url = "https://downloads.typesafe.com/scalaide-pack/4.7.0-vfinal-oxygen-212-20170929/scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz";
          sha256  = "1n5w2a7mh9ajv6fxcas1gpgwb04pdxbr9v5dzr67gsz5bhahq4ya";
        };
  }).overrideAttrs(oa: {
    # Only download for x86_64
    meta.platforms = [ "x86_64-linux" ];
  });

  ### Eclipse SDK

  eclipse-sdk = buildEclipse {
    name = "eclipse-sdk-${platform_major}.${platform_minor}";
    description = "Eclipse ${year}-${month} Classic";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-SDK-${platform_major}.${platform_minor}-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-zb6/AMe7ArSw1mzPIvaSVeuNly6WO7pHQAuYUT8eGkk=";
          aarch64 = "sha256-jgT3BpD04ELV2+WuRw1mbDw6S1SYDo7jfrijSNs8GLM=";
        }.${arch};
      };
  };

  ### Eclipse Java

  eclipse-java = buildEclipse {
    name = "eclipse-java-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Java Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-java-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-fXfj0PImyd2nPUkaGvOu7BGAeIHkTocKH94oM/Vd+LU=";
          aarch64 = "sha256-0EZXbngXIso8fS8bvSDPyRGCre2dF0+6wyldQ6GhGmo=";
        }.${arch};
      };
  };

  ### Eclipse Java EE

  eclipse-jee = buildEclipse {
    name = "eclipse-jee-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Enterprise Java and Web Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-jee-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-YIoa837bbnqm/4wuwRfx+5UNxyQJySbTX+lhL/FluS0=";
          aarch64 = "sha256-0hwKU29RJdjyaF4ot0OpXt/illOsx1n38nhK5zteQBk=";
        }.${arch};
      };
  };

  ### Eclipse Committers

  eclipse-committers = buildEclipse {
    name = "eclipse-committers-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for Eclipse Committers and Eclipse Platform Plugin Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-committers-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-IFQkSOs0wk7chR9Ti3WG/7WDrXBWnaRH9AqC9jTmuT8=";
          aarch64 = "sha256-iiS3hZWfinHYVhZsMntXQp+OgL7kcE/2jqx2JomBdIk=";
        }.${arch};
      };
  };

  ### Eclipse IDE for RCP and RAP Developers

  eclipse-rcp = buildEclipse {
    name = "eclipse-rcp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for RCP and RAP Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-rcp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha256-+U3wHbUgxkqWZjZyAXAqkZHeoNp+CwL1NBO4myDdJhE=";
          aarch64 = "sha256-zDLt3lOqf2HyUP/oqbff6XupF2Vab7+gxpQriztunH4=";
        }.${arch};
      };
  };

  ### Environments

  # Function that assembles a complete Eclipse environment from an
  # Eclipse package and list of Eclipse plugins.
  eclipseWithPlugins = { eclipse, plugins ? [], jvmArgs ? [] }:
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
      jvmArgsText = lib.concatStringsSep "\n" (jvmArgs ++ [dropinProp]);

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

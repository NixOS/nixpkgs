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
# for e in cpp dsl modeling platform sdk java jee committers rcp; do for s in pkgs pkgsCross.aarch64-multiplatform; do echo; echo $s $e; nix build -f default.nix ${s}.eclipses.eclipse-${e} -o eclipse-${s}-${e}; done; done

let
  platform_major = "4";
  platform_minor = "30";
  year = "2023";
  month = "12"; #release month
  buildmonth = "12"; #sometimes differs from release month
  timestamp = "${year}${buildmonth}010110";
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
          x86_64 = "sha256-a5GqbghNlyvU/S36NcFSel1GRf/vZp01aaCxAswqyng=";
          aarch64 = "sha256-w2bzolYBA4bf4kfcPza0LDLViKqXQkbZR07STN94nrY=";
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
          x86_64 = "sha256-U9CMwcDZP1ptnc+C7gTfTOcyppe7r6RtgPp65b3A7Qk=";
          aarch64 = "sha256-wuh6IZtRPDNJAVcfukFjZfuOVJgfj2zI616YNDnRgWM=";
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
          x86_64 = "sha256-h1d0LTBKBKcYxeLr0QEK7VG3q8cKeHQPaKzoPU6qlkI=";
          aarch64 = "sha256-nCkNNmL924I8Q6wjAmik7d3K4T4j0/Biyr4d9Y0KfSg=";
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
          x86_64 = "sha256-FbcSbDFyjx2uG0T844cBwAdaBZc2k/c4aogsCVYI7+E=";
          aarch64 = "sha256-COQipICwcM7+gbpiD/G31bsW+9NDz8wt+HyY6FFkKos=";
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
          x86_64 = "sha256-3UfaIwUpgD+VWB7Ar5by78zldqmrlg9csINkre+m8i0=";
          aarch64 = "sha256-5wIlnTItwEstUHitlVPIxY7ayvxV4yI/8ID8WQ3mnDI=";
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
          x86_64 = "sha256-Cf2jrNjakRteGO/W18oneE9EDM3VLyi/lIafgffprUc=";
          aarch64 = "sha256-j0i1k3fHQ/+P5y6aRKUZM8uBQJOLweDtkjneqlx/kuQ=";
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
          x86_64 = "sha256-pN+x63J8+GhGmfsdzLknJXWCnvhS8VeLizmyqWM8XUA=";
          aarch64 = "sha256-QVW2nx5P6mkj4oJ1qHs5D2TZBuBuxayhiJHh0VgAghU=";
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
          x86_64 = "sha256-Qj9Omc3+HP3twF0evhkRKE8PH/i4+eGtnkfjUu9+lY4=";
          aarch64 = "sha256-DqkwHyEbttFBA9HM3GdqxxZNjCiKf6gS7KNQYIUBAGE=";
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
          x86_64 = "sha256-zhQU7hSF3KWJ0Q2TRzvGhL76Mxhhh/HS/wT/ahkFHXk=";
          aarch64 = "sha256-XSqWx1V0XjtuYbZlRcJf7Xu1yL1VazT5Z/BcGkkXzb8=";
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
        paths =
          with lib;
            filter (x: x ? isEclipsePlugin) (closePropagation plugins);
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

  plugins = callPackage ./plugins.nix { } // { __attrsFailEvaluation = true; };

}

{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, gtk2, libXtst, jdk, jdk8, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser
, buildEnv, runCommand
, callPackage
}:

# https://download.eclipse.org/eclipse/downloads/ is the main place to
# find the downloads needed for new versions
#
# to test:
# $ for e in cpp modeling platform sdk java jee committers rcp; do nix build -f default.nix pkgs.eclipses.eclipse-${e} -o eclipse-${e}; done

let
  platform_major = "4";
  platform_minor = "26";
  year = "2022";
  month = "12"; #release month
  buildmonth = "11"; #sometimes differs from release month
  timestamp = "${year}${buildmonth}231800";
  gtk = gtk3;
  arch = if stdenv.hostPlatform.isx86_64 then
    "x86_64"
  else if stdenv.hostPlatform.isAarch64 then
    "aarch64"
  else throw "don't know what platform suffix for ${stdenv.hostPlatform.system} will be";
in rec {

  buildEclipse = callPackage ./build-eclipse.nix {
    inherit stdenv makeDesktopItem freetype fontconfig libX11 libXrender zlib
            jdk glib gtk libXtst gsettings-desktop-schemas webkitgtk
            makeWrapper;
  };

  ### Eclipse CPP

  eclipse-cpp = buildEclipse {
    name = "eclipse-cpp-${platform_major}.${platform_minor}";
    description = "Eclipse IDE for C/C++ Developers";
    src =
      fetchurl {
        url = "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-cpp-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
        hash = {
          x86_64 = "sha512-nqqY4dewq1bjeNoZdWvOez+cBti+f9qXshx1eqJ2lB7sGJva5mcR9e+CZTVD0+EtVJ/U+8viJ+E1Veht1ZnqOw==";
          aarch64 = "sha512-kmeNH6F8oK72LtrYtiJVLKhy6Q1HwnU+Bh+mpXdXSrfj9KtqzHQkJ0kTnnJkGYLtpi+zyXDwsxzyjh6pPyDRJA==";
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
          x86_64 = "sha512-WU2BJt6GL3ug3yOUOd5y6/AbGLcr2MkCg+QJiNIMkSXvoU9TF6R6oimoGVc3kPZmazRy6WYoes55T3bWrHnO8Q==";
          aarch64 = "sha512-F63f2o9u/p7hhrxI+Eu6NiL4sPccIYw876Nnj8mfSZ7bozs1OVNWftZj+xbdLLbr0bVz3WKnt4BHzcLUA6QG7g==";
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
          x86_64 = "sha512-hmdWGteMDt4HhYq+k9twuftalpTzHtGnVVLphZcpJcw+6vJfersciDMaeLRqbCAeFbzJdgzjYo76bpP6FubySw==";
          aarch64 = "sha512-BvUkOdCsjwtscPeuBXG7ZpitOr8EQK5JL8nSGpw/RhhBEFz46nsc7W18l0aYjdzRHh2ie55RylS2PEQELkS/hQ==";
        }.${arch};
      };
  };

  ### Eclipse Scala SDK

  eclipse-scala-sdk =
    (buildEclipse.override { jdk = jdk8; gtk = gtk2; } {
      name = "eclipse-scala-sdk-4.7.0";
      description = "Eclipse IDE for Scala Developers";
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
          x86_64 = "sha512-hmdWGteMDt4HhYq+k9twuftalpTzHtGnVVLphZcpJcw+6vJfersciDMaeLRqbCAeFbzJdgzjYo76bpP6FubySw==";
          aarch64 = "sha512-UYp8t7r2RrN3rKN180cWpJyhyO5LVXL8LrTRKJzttUgB7kM1nroTEI3DesBu+Hw4Ynl7eLiBK397rqcpOAfxJw==";
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
          x86_64 = "sha512-71mXYVLVnyDjYZbJGBKc0aDPq8sbTxlVZRQq7GlSUDv2fsoNYWYgqYfK7RSED5yoasCfs3HUYr7QowRAKJOnfQ==";
          aarch64 = "sha512-KOQ6BZuQJeVpbMQVxF67M3F/KXMmDhmZQBNq0yWM+/8+d0DiBRkwJtqPYsnTqrax8FSunn2yy+CzlfyHSoNvpg==";
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
          x86_64 = "sha512-55i9YVOa+vKHt72vHIqy9BmKMkg1KaLqMStjTtfaLTH5yP0ei+NTP2XL8IBHOgu0hCEJqYXTq+3I3RQy476etQ==";
          aarch64 = "sha512-iaoTB/Pinoj1weiGBBv0plQ4jGNdFs2JiBG7S/icUoAX5O6jTGAgJvOwh7Nzn+0N6YL6+HPWaV24a6lM43y8Og==";
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
          x86_64 = "sha512-zGeynifM0dn1214HEVS7OVtv7xa8asjLzOXh5riJK8c/DWvNrRduHn6o6PGnxYOYVIfC9BzNRAjG1STkWu9j+Q==";
          aarch64 = "sha512-B866dFJcsTkq+h0RZ61CxXE83TWvCf8ZAbGeIC385PpPR3i/gZnRjN2oRrDP22CNR5XXA+PfXKxqvERhJB5ebA==";
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
          x86_64 = "sha256-ml76ix0fHuR0KqYWQuTftEBAgq7iaOIyvr8V6WhuzeU=";
          aarch64 = "sha256-sMB6a3f0fiL6ZentIjJTMi59ZOh7dizXrkMQuIRbds0=";
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

  plugins = callPackage ./plugins.nix { };

}

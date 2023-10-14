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
# for e in cpp modeling platform sdk java jee committers rcp; do for s in pkgs pkgsCross.aarch64-multiplatform; do echo; echo $s $e; nix build -f default.nix ${s}.eclipses.eclipse-${e} -o eclipse-${s}-${e}; done; done

let
  platform_major = "4";
  platform_minor = "28";
  year = "2023";
  month = "06"; #release month
  buildmonth = "06"; #sometimes differs from release month
  timestamp = "${year}${buildmonth}050440";
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
          x86_64 = "sha256-0VFg68+M84SEPbLv2f3hNTK1tvUjN3u0X3DYFCMAFX8=";
          aarch64 = "sha256-K1e1Q//X+R4FfY60eE4nPgEaF0wUkUIO/AFzzjIrGRY=";
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
          x86_64 = "sha256-wdZninKynNQ5o2nxyOxA7GDQ75tWs1TB2jh21O0fEpg=";
          aarch64 = "sha256-5iAoMyesBjmdAy/eSMkgtuYv5rnXAEjgLb0yNX02mdw=";
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
          x86_64 = "sha256-SYeCXWGSi8bPbqngGC+ZSBQaKyZrDTFeT+RLKC+ZsDk=";
          aarch64 = "sha256-DN6fl7p+q96wsg9Mq6v3lTV0/7b87MFKTJSFuNrjLgs=";
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
          x86_64 = "sha256-QY16KSNZj6rq7YL+gOajI80XVtSdCh7MJGPscRJuf1o=";
          aarch64 = "sha256-oZXx87dlLZ61ezwDD0WnV48ZMjcK0FkSGl83LhkJvmc=";
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
          x86_64 = "sha256-FC4zgx+75S9TJVp0azWgON/wNmoEy0074tj+DOdvNOg=";
          aarch64 = "sha256-wnRQKqg1V4hrD9VAg6sw8yypB97Wcivt4cH6MFP4KPs=";
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
          x86_64 = "sha256-eSYWuw6s3H1ht4zPDwjd4oZ49KhIn1OaywtwKHyS0wI=";
          aarch64 = "sha256-9O0+S3G3vtjN1Vd4euf3gYRPPtrVxoBB+Uj7BlDAS5M=";
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
          x86_64 = "sha256-kJoXaSwsjArpe4tqeSkZiU4AcR5dLBvdsyU7tBTiTdc=";
          aarch64 = "sha256-qydFxa0lQEwsxZQPlBXV/wiuXGuIcBHRasKZEmXJaOk=";
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
          x86_64 = "sha256-BAEXN6sx4f+BJnKz0lkPoAmRXnlbl5s5ETAyfE/AZak=";
          aarch64 = "sha256-xayvsFAglBxAB49j2tnt52d6KX6LxMBRfx0wR/p8K70=";
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

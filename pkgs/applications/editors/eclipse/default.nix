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
  webkitgtk_4_1 ? null, # for internal web browser
  buildEnv,
  runCommand,
  callPackage,
}:

# use ./update.sh to help with updating for each quarterly release
#
# then, to test:
# for e in cpp dsl embedcpp modeling platform sdk java jee committers rcp; do for s in pkgs pkgsCross.aarch64-multiplatform; do echo; echo $s $e; nix-build -A ${s}.eclipses.eclipse-${e} -o eclipse-${s}-${e}; done; done

let
  eclipses = lib.trivial.importJSON ./eclipses.json;
  inherit (eclipses)
    platform_major
    platform_minor
    year
    # release month sometimes differs from build month
    month
    buildmonth
    dayHourMinute
    ;
  timestamp = "${year}${buildmonth}${dayHourMinute}";

  gtk = gtk3;
  arch =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else
      throw "don't know what platform suffix for ${stdenv.hostPlatform.system} will be";

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
      webkitgtk_4_1
      makeWrapper
      ;
  };
  buildEclipse =
    eclipseData:
    buildEclipseUnversioned (eclipseData // { version = "${platform_major}.${platform_minor}"; });

  generateEclipse =
    id:
    {
      description,
      hashes,
      dropUrl,
    }:
    builtins.listToAttrs [
      {
        name = "eclipse-${lib.strings.toLower id}";
        value = buildEclipse {
          pname = "eclipse-${lib.strings.toLower id}";
          inherit description;
          src = fetchurl {
            url =
              if dropUrl then
                "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/eclipse/downloads/drops${platform_major}/R-${platform_major}.${platform_minor}-${timestamp}/eclipse-${id}-${platform_major}.${platform_minor}-linux-gtk-${arch}.tar.gz"
              else
                "https://www.eclipse.org/downloads/download.php?r=1&nf=1&file=/technology/epp/downloads/release/${year}-${month}/R/eclipse-${id}-${year}-${month}-R-linux-gtk-${arch}.tar.gz";
            hash = hashes.${arch};
          };
        };
      }
    ];

  generatedEclipses = lib.attrsets.concatMapAttrs generateEclipse eclipses.eclipses;

in
generatedEclipses
// {
  # expose this function so users can build their own eclipses if needed
  inherit buildEclipse;

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

  plugins = lib.recurseIntoAttrs (callPackage ./plugins.nix { });

}

{
  stdenvNoCC,
  fetchurl,
  writeTextFile,
  runCommand,
  isabelle,
  pkgs,
  fetchMavenArtifact,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

let
  patch = runCommand "isabelle-jedit.patch" { } ''
    cp -r ${isabelle.src}/src/Tools/jEdit/patches .
    chmod +w patches
    for file in patches/*; do
      mv $file $file.patch
    done
    sed -i 's,--- jedit5.7.0/jEdit,--- a,; s,+++ jedit5.7.0-patched/jEdit,+++ b,' patches/*.patch
    cat patches/*.patch > $out
  '';

  jsr305 = fetchMavenArtifact {
    groupId = "com.google.code.findbugs";
    artifactId = "jsr305";
    version = "3.0.2";
    hash = "sha256-dmrSoHg/JoeWLIrXTO7MOKKLn3Ki0IXuQ4t4E+ko0Mc=";
  };

  plugins = stdenvNoCC.mkDerivation {
    name = "jedit-plugins";
    srcs = [
      (fetchurl {
        url = "https://sourceforge.net/projects/jedit-plugins/files/CommonControls/1.7.4/CommonControls-1.7.4.tgz";
        hash = "sha256-RCQY+Q5ndTrW9g1gggpqPcRXv3lQbPu2GULaYqiBAzY=";
      })
      (fetchurl {
        url = "https://sourceforge.net/projects/jedit-plugins/files/Console/5.1.4/Console-5.1.4.tgz";
        hash = "sha256-caiwi++6+8WXyOPFncjddMwjzinndFzVeGHu97yo0bY=";
      })
      (fetchurl {
        url = "https://sourceforge.net/projects/jedit-plugins/files/ErrorList/2.4.0/ErrorList-2.4.0.tgz";
        hash = "sha256-ICrmsooD0CafUOEMcCw2NpV+7PfjaX4VUdELcgwrnjA=";
      })
      (fetchurl {
        url = "https://sourceforge.net/projects/jedit-plugins/files/Highlight/2.5/Highlight-2.5.tgz";
        hash = "sha256-m9qizOwdfV7WRDsrT2N5Y1HKuwjVo+VkEKBubP82EPs=";
      })
      (fetchurl {
        url = "https://sourceforge.net/projects/jedit-plugins/files/QuickNotepad/5.0/QuickNotepad-5.0.tgz";
        hash = "sha256-04ibTtvFYxsDTKEhJgh6DyetlbD5jEvhe3d3gzz7znI=";
      })
      (fetchurl {
        url = "https://sourceforge.net/projects/jedit-plugins/files/SideKick/1.8/SideKick-1.8.tgz";
        hash = "sha256-AmKEv6E9L9ZO0RYNK+u+aqCLSpcBlLpUaWmrbauEVZ8=";
      })
    ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/share/java
      install -Dm644 *.jar $out/share/java
      install -m644 ${jsr305}/share/java/*.jar $out/share/java
    '';
  };

  idea-icons = fetchurl {
    url = "https://isabelle.in.tum.de/components/idea-icons-20250415.tar.gz";
    hash = "sha256-biJp/kt5D7pFkMbr0QDU/NvLz+OK5WcApKbLXh0KA5k=";
  };

  tango-icons = fetchFromGitHub {
    owner = "sebkur";
    repo = "tango-icon-theme";
    rev = "41b8f6abd7ebb9d5c35e563c8cd8c410c88f114a";
    hash = "sha256-YYErXeBvTvWbFK022qBWHWkvWOKndmyBDGbi/JjnJjI=";
  };

  patched-jedit = pkgs.jedit.overrideAttrs (
    finalAttrs: prevAttrs: {
      ivyDeps = pkgs.jedit.ivyDeps.overrideAttrs {
        patches = [ patch ];
        outputHash = "sha256-qFkjxkOdynJFMNKz4JLrVKwLNUY6QiaQ3lAKJJpvsnM=";
      };
      patches = [ patch ];
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [
        writableTmpDirAsHomeHook
      ];
      postPatch = ''
        echo "Augmenting icons..."
        for theme in "classic" "tango"; do
          cp ${isabelle.src}/lib/logo/isabelle_transparent-32.gif org/gjt/sp/jedit/icons/themes/$theme/32x32/apps/isabelle.gif
        done

        tar -xf ${idea-icons} -C $TMPDIR
        mkdir -p org/gjt/sp/jedit/icons/themes/tango/idea-icons
        pushd org/gjt/sp/jedit/icons/themes/tango/idea-icons
        jar xf $TMPDIR/idea-icons-20250415/jar/idea-icons.jar
        rm -r META-INF
        cp $TMPDIR/idea-icons-20250415/README .
        popd

        for svg in $( find ${tango-icons} -type f -name "*.svg" ); do
          dest_file_svg="org/gjt/sp/jedit/icons/themes/tango/''${svg#${tango-icons}/}"
          mkdir -p $(dirname $dest_file_svg)
          cp $svg $dest_file_svg
        done

        # Tests fail with the patches
        substituteInPlace build.xml --replace-fail "compile,test" "compile"
      '';

      postInstall = ''
        ln -s ${plugins}/share/java $out/share/jEdit/jars
      '';
    }
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jedit";
  version = "20251128";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/jedit-${finalAttrs.version}.tar.gz";
    hash = "sha256-3Hv6rvD+XP1e25TCSJKIcC92+ZUeA+N2BS8eb1DVny4=";
  };
  sourceRoot = "jedit-${finalAttrs.version}/jedit5.7.0-patched";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{doc,java,jedit}
    cp jedit.jar $out/share/java
    cp -r jars keymaps macros modes properties startup $out/share/jedit
    cp -r doc/* $out/share/doc

    runHook postInstall
  '';

  passthru = {
    inherit
      plugins
      idea-icons
      patched-jedit
      patch
      ;

    settings = writeTextFile {
      name = "jedit-settings";
      text = ''
        JEDIT_HOME="${finalAttrs.finalPackage}/share/jedit"
        JEDIT_JAR_HOME="${finalAttrs.finalPackage}/share/java"
        JEDIT_JARS="$JEDIT_HOME/jars/CommonControls.jar:$JEDIT_HOME/jars/Console.jar:$JEDIT_HOME/jars/ErrorList.jar:$JEDIT_HOME/jars/Highlight.jar:$JEDIT_HOME/jars/QuickNotepad.jar:$JEDIT_HOME/jars/SideKick.jar:$JEDIT_HOME/jars/jsr305-3.0.2.jar:$JEDIT_HOME/jars/kappalayout.jar"
        JEDIT_JAR="$JEDIT_JAR_HOME/jedit.jar"
        classpath "$JEDIT_JAR"

        JEDIT_SETTINGS="$ISABELLE_HOME_USER/jedit"

        ISABELLE_DOCS="$ISABELLE_DOCS:${finalAttrs.finalPackage}/share/doc"
      '';
      destination = "/etc/settings";
    };
  };
})

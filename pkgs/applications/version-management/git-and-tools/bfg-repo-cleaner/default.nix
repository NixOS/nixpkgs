{ stdenv, fetchurl, jre, makeWrapper }:

let
  version = "1.12.15";
  jarName = "bfg-${version}.jar";
  mavenUrl = "http://central.maven.org/maven2/com/madgag/bfg/${version}/${jarName}";
in
  stdenv.mkDerivation {
    inherit version jarName;

    name = "bfg-repo-cleaner";

    src = fetchurl {
      url = mavenUrl;
      sha256 = "17dh25jambkk55khknlhy8wa9s1i1xmh9hdgj72j1lzyl0ag42ik";
    };

    buildInputs = [ jre makeWrapper ];

    phases = "installPhase";

    installPhase = ''
      mkdir -p $out/share/java
      mkdir -p $out/bin
      cp $src $out/share/java/$jarName
      makeWrapper "${jre}/bin/java" $out/bin/bfg --add-flags "-cp $out/share/java/$jarName com.madgag.git.bfg.cli.Main"
    '';

    meta = with stdenv.lib; {
      homepage = https://rtyley.github.io/bfg-repo-cleaner/;
      # Descriptions taken with minor modification from the homepage of bfg-repo-cleaner
      description = "Removes large or troublesome blobs in a git repository like git-filter-branch does, but faster";
      longDescription = ''
        The BFG is a simpler, faster alternative to git-filter-branch for
        cleansing bad data out of your Git repository history, in particular removing
        crazy big files and removing passwords, credentials, and other private data.

        The git-filter-branch command is enormously powerful and can do things
        that the BFG can't - but the BFG is much better for the tasks above, because
        it's faster (10-720x), simpler (dedicated to just removing things), and
        beautiful (can use Scala instead of bash to script customizations).
      '';
      license = licenses.gpl3;
      maintainers = [ maintainers.changlinli ];
      platforms = platforms.unix;
      downloadPage = "https://mvnrepository.com/artifact/com.madgag/bfg/${version}";
    };

  }

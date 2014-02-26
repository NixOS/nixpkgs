{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git
}:

let

  buildIdea =
  { name, src, description, license }:

  stdenv.mkDerivation rec {
    inherit name src license;
    ideaItem = makeDesktopItem {
      name = "IDEA";
      exec = "idea";
      comment = "Integrated Development Environment";
      desktopName = "IntelliJ IDEA";
      genericName = "Integrated Development Environment";
      categories = "Application;Development;";
    };

    buildInputs = [ makeWrapper patchelf p7zip ];

    buildCommand = ''
      tar xvzf $src
      mkdir -p $out
      cp -a $name $out

      interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)

      7z x $out/$name/lib/snappy-java-1.0.5.jar
      rm $out/$name/lib/snappy-java-1.0.5.jar
      if [ "${stdenv.system}" == "x86_64-linux" ];then
        patchelf --set-interpreter $interpreter $out/$name/bin/fsnotifier64
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib64/ org/xerial/snappy/native/Linux/amd64/libsnappyjava.so
      else
        patchelf --set-interpreter $interpreter $out/$name/bin/fsnotifier
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib/ org/xerial/snappy/native/Linux/i386/libsnappyjava.so
      fi
      7z a -tzip $out/$name/lib/snappy-java-1.0.5.jar .

      mkdir -p $out/bin

      jdk=${jdk}/lib/openjdk

      makeWrapper $out/$name/bin/idea.sh $out/bin/idea \
        --prefix PATH : ${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin \
        --prefix LD_RUN_PATH : ${stdenv.gcc.gcc}/lib/ \
        --prefix JDK_HOME : $jdk \
        --prefix IDEA_JDK : $jdk

        mkdir -p $out/share/applications
        cp ${ideaItem}/share/applications/* $out/share/applications
        patchShebangs $out
    '';

    meta = {
      homepage = http://www.jetbrains.com/idea/;
      inherit description;
      inherit license;
      maintainers = [ stdenv.lib.maintainers.edwtjo ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

in {

  idea_community_1302 = buildIdea {
    name = "idea-IC-133.696";
    description = "IntelliJ IDEA 13 Community Edition";
    license = stdenv.lib.licenses.asl20.shortName;
    src = fetchurl {
      url = http://download-ln.jetbrains.com/idea/ideaIC-13.0.2.tar.gz;
      sha256 = "a776878c2dba877761b74d2886d006f64eec3c9694dbd1578380287a9c8cbd53";
    };
  };

  idea_ultimate_1302 = buildIdea {
    name = "idea-IU-133.696";
    description = "IntelliJ IDEA 13 Ultimate Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = http://download-ln.jetbrains.com/idea/ideaIU-13.0.2.tar.gz;
      sha256 = "7ba9499ecc82029470712d6ead520db1e2cf520e4f86d382cbdea1d0052712d0";
    };
  };

}

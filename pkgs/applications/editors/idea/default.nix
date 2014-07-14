{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git
}:

let

  buildIdea =
  { name, version, build, src, description, license }:

  stdenv.mkDerivation rec {
    inherit name build src license;
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
      cp -a idea-$build $out

      interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)

      7z x $out/idea-$build/lib/snappy-java-1.0.5.jar
      rm $out/idea-$build/lib/snappy-java-1.0.5.jar
      if [ "${stdenv.system}" == "x86_64-linux" ];then
        patchelf --set-interpreter $interpreter $out/idea-$build/bin/fsnotifier64
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib64/ org/xerial/snappy/native/Linux/amd64/libsnappyjava.so
      else
        patchelf --set-interpreter $interpreter $out/idea-$build/bin/fsnotifier
        patchelf --set-rpath ${stdenv.gcc.gcc}/lib/ org/xerial/snappy/native/Linux/i386/libsnappyjava.so
      fi
      7z a -tzip $out/idea-$build/lib/snappy-java-1.0.5.jar .

      mkdir -p $out/bin

      jdk=${jdk}/lib/openjdk

      makeWrapper $out/idea-$build/bin/idea.sh $out/bin/idea \
        --prefix PATH : ${jdk}/bin:${coreutils}/bin:${gnugrep}/bin:${which}/bin:${git}/bin \
        --prefix LD_RUN_PATH : ${stdenv.gcc.gcc}/lib/ \
        --prefix JDK_HOME : $jdk \
        --prefix IDEA_JDK : $jdk

        mkdir -p $out/share/applications
        cp "${ideaItem}/share/applications/"* $out/share/applications
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

  idea_community = buildIdea rec {
    name = "idea-community-${version}";
    version = "13.1.3";
    build = "IC-135.909";
    description = "IntelliJ IDEA 13 Community Edition";
    license = stdenv.lib.licenses.asl20.shortName;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "62ed937ef68df16eef4d32772b6510835527f95020db1c76643f17ed2c067b51";
    };
  };

  idea_ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "13.1.3";
    build = "IU-135.909";
    description = "IntelliJ IDEA 13 Ultimate Edition";
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "6d99e49a63a197e19381a85535ab424a7832653db8cceb3bca7d53615ec7a53d";
    };
  };

}

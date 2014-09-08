{ stdenv, fetchurl, makeDesktopItem, makeWrapper, patchelf, p7zip, jdk
, coreutils, gnugrep, which, git
}:

assert stdenv.isLinux;

let

  buildIdea =
  { name, version, build, src, description, longDescription, license }:

  stdenv.mkDerivation rec {
    inherit name build src;
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
      inherit longDescription;
      inherit license;
      maintainers = [ stdenv.lib.maintainers.edwtjo ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

in {

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "13.1.4b";
    build = "IC-135.1230";
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    longDescription = ''
      Lightweight IDE for Java SE, Groovy & Scala development
      Powerful environment for building Google Android apps
      Integration with JUnit, TestNG, popular SCMs, Ant & Maven
      Free, open-source, Apache 2 licensed.
    '';
    license = stdenv.lib.licenses.asl20;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "8b4ee25fd2934e06b87230b50e1474183ed4b331c1626a7fee69b96294d9616d";
    };
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "13.1.4b";
    build = "IU-135.1230";
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    longDescription = ''
      Full-featured IDE for JVM-based and polyglot development
      Java EE, Spring/Hibernate and other technologies support
      Deployment and debugging with most application servers
      Duplicate code search, dependency structure matrix, etc.
    '';
    license = stdenv.lib.licenses.unfree;
    src = fetchurl {
      url = "http://download-ln.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "84660d97c9c3e4e7cfd6c2708f4685dc7322157f1e1c2888feac64df119f0606";
    };
  };

}

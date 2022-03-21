{ lib, stdenv
, fetchurl
, jdk
, gradle_7
, perl
, jre
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, testVersion
, key
}:

let
  pname = "key";
  version = "2.10.0";
  src = fetchurl {
    url = "https://www.key-project.org/dist/${version}/key-${version}-sources.tgz";
    sha256 = "1f201cbcflqd1z6ysrkh3mff5agspw3v74ybdc3s2lfdyz3b858w";
  };
  sourceRoot = "key-${version}/key";

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src sourceRoot;
    nativeBuildInputs = [ gradle_7 perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      # https://github.com/gradle/gradle/issues/4426
      ${lib.optionalString stdenv.isDarwin "export TERM=dumb"}
      gradle --no-daemon classes testClasses
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-GjBUwJxeyJA6vGrPQVtNpcHb4CJlNlY4kHt1PT21xjo=";
  };
in stdenv.mkDerivation rec {
  inherit pname version src sourceRoot;

  nativeBuildInputs = [
    jdk
    gradle_7
    makeWrapper
    copyDesktopItems
  ];

  executable-name = "KeY";

  desktopItems = [
    (makeDesktopItem {
      name = "KeY";
      exec = executable-name;
      icon = "key";
      comment = meta.description;
      desktopName = "KeY";
      genericName = "KeY";
      categories = [ "Science" ];
    })
  ];

  # disable tests (broken on darwin)
  gradleAction = if stdenv.isDarwin then "assemble" else "build";

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    # https://github.com/gradle/gradle/issues/4426
    ${lib.optionalString stdenv.isDarwin "export TERM=dumb"}
    # point to offline repo
    sed -ie "s#repositories {#repositories { maven { url '${deps}' }#g" build.gradle
    cat <(echo "pluginManagement { repositories { maven { url '${deps}' } } }") settings.gradle > settings_new.gradle
    mv settings_new.gradle settings.gradle
    gradle --offline --no-daemon ${gradleAction}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp key.ui/build/libs/key-*-exe.jar $out/share/java/KeY.jar
    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp key.ui/src/main/resources/de/uka/ilkd/key/gui/images/key-color-icon-square.png $out/share/icons/hicolor/256x256/apps/key.png
    makeWrapper ${jre}/bin/java $out/bin/KeY \
      --add-flags "-cp $out/share/java/KeY.jar de.uka.ilkd.key.core.Main"

    runHook postInstall
  '';

  passthru.tests.version =
    testVersion {
      package = key;
      command = "KeY --help";
    };

  meta = with lib; {
    description = "Java formal verification tool";
    homepage = "https://www.key-project.org"; # also https://formal.iti.kit.edu/key/
    longDescription = ''
      The KeY System is a formal software development tool that aims to
      integrate design, implementation, formal specification, and formal
      verification of object-oriented software as seamlessly as possible.
      At the core of the system is a novel theorem prover for the first-order
      Dynamic Logic for Java with a user-friendly graphical interface.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}


{
  stdenv,
  lib,
  fetchFromGitHub,
  jdk,
  maven,
  which,
}:
let
  pname = "jnr-posix";
  version = "3.1.18";

  src = fetchFromGitHub {
    owner = "jnr";
    repo = "jnr-posix";
    rev = "jnr-posix-${version}";
    hash = "sha256-zx8I9rsu9Kjef+LatDA1WIuO7Vgo0/JM5nGi3pSWch4=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-${version}-deps";
    inherit src;

    nativeBuildInputs = [
      jdk
      maven
    ];

    buildPhase = ''
      runHook preBuild

      mvn package -Dmaven.test.skip=true -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000

      runHook postBuild
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      runHook preInstall

      find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
      find $out/.m2 -type f -iname '*.pom' -exec sed -i -e 's/\r\+$//' {} \;

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-gOw0KUFyZEMONwLwlHSiV+ZZ7JQhjZwg708Q1IciUfo=";

    doCheck = false;
  };
in
stdenv.mkDerivation rec {
  inherit version pname src;

  nativeBuildInputs = [
    maven
    which
  ];

  postPatch = ''
    sed -i "s/\/usr\/bin\/id/$(which id | sed 's#/#\\/#g')/g" src/main/java/jnr/posix/JavaPOSIX.java
  '';

  buildPhase = ''
    runHook preBuild

    mvn package --offline -Dmaven.test.skip=true -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D target/jnr-posix-${version}.jar $out/share/java/jnr-posix-${version}.jar

    runHook postInstall
  '';

  meta = with lib; {
    description = "jnr-posix is a lightweight cross-platform POSIX emulation layer for Java, written in Java and is part of the JNR project";
    homepage = "https://github.com/jnr/jnr-posix";
    license = with licenses; [
      epl20
      gpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}

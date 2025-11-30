{
  lib,
  stdenv,
  fetchurl,
  ant,
  jdk,
  stripJavaArchivesHook,
  cunit,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "java-service-wrapper";
  version = "3.6.3";

  src = fetchurl {
    url = "https://wrapper.tanukisoftware.com/download/${finalAttrs.version}/wrapper_${finalAttrs.version}_src.tar.gz";
    hash = "sha256-e8Wtie0ho5tKTtVI3+kvxYeu1A5sdQWacTCfuAQv9YA=";
  };

  strictDeps = true;

  buildInputs = [
    cunit
    ncurses
  ];

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
  ];

  postConfigure = ''
    substituteInPlace default.properties \
      --replace-fail "javac.target.version=1.4" "javac.target.version=8"
  '';

  buildPhase = ''
    runHook preBuild

    export JAVA_HOME=${jdk}/lib/openjdk/
    export JAVA_TOOL_OPTIONS=-Djava.home=$JAVA_HOME
    export CLASSPATH=${jdk}/lib/openjdk/lib/tools.jar

    ant -f build.xml -Dbits=${if stdenv.hostPlatform.isi686 then "32" else "64"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp bin/wrapper $out/bin/wrapper
    cp lib/wrapper.jar $out/lib/wrapper.jar
    cp lib/libwrapper.so $out/lib/libwrapper.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Enables a Java Application to be run as a Windows Service or Unix Daemon";
    homepage = "https://wrapper.tanukisoftware.com/";
    changelog = "https://wrapper.tanukisoftware.com/doc/english/release-notes.html#${finalAttrs.version}";
    license = licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    maintainers = [ maintainers.suhr ];
    mainProgram = "wrapper";
    # Broken for Musl at 2024-01-17. Errors as:
    # logger.c:81:12: fatal error: gnu/libc-version.h: No such file or directory
    # Tracking issue: https://github.com/NixOS/nixpkgs/issues/281557
    broken = stdenv.hostPlatform.isMusl;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk25_headless,
  maven,
  makeWrapper,
}:

let
  platform =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "mac"
    else if stdenv.hostPlatform.isWindows then
      "windows"
    else
      throw "unsupported platform";
in
maven.buildMavenPackage {
  pname = "java-language-server";
  version = "0.2.49";

  src = fetchFromGitHub {
    owner = "georgewfraser";
    repo = "java-language-server";
    # commit hash is used as owner sometimes forgets to set tags. See https://github.com/georgewfraser/java-language-server/issues/104
    rev = "58daaa29a0e2fe22764283607da6801cf8b493b9";
    hash = "sha256-rHtnsZxcZKq1IGZJXE8nkv2iyS09kuNlqaVsRWpMwjM=";
  };

  mvnFetchExtraArgs.dontConfigure = true;
  mvnJdk = jdk25_headless;
  mvnHash = "sha256-mSjz5OM/tMZuiX4kmB1DprvQuIP4EzeDpAr4oQ5T11s=";

  nativeBuildInputs = [
    jdk25_headless
    makeWrapper
  ];

  dontConfigure = true;
  preBuild = ''
    jlink \
      ${
        lib.optionalString (!stdenv.hostPlatform.isDarwin) "--module-path './jdks/${platform}/jdk-13/jmods'"
      } \
      --add-modules java.base,java.compiler,java.logging,java.sql,java.xml,jdk.compiler,jdk.jdi,jdk.unsupported,jdk.zipfs \
      --output dist/${platform} \
      --no-header-files \
      --no-man-pages \
      --compress 2
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java/java-language-server
    cp -r dist/classpath dist/*${platform}* $out/share/java/java-language-server

    # a link is not used as lang_server_${platform}.sh makes use of "dirname $0" to access other files
    makeWrapper $out/share/java/java-language-server/lang_server_${platform}.sh $out/bin/java-language-server

    runHook postInstall
  '';

  meta = {
    description = "Java language server based on v3.0 of the protocol and implemented using the Java compiler API";
    mainProgram = "java-language-server";
    homepage = "https://github.com/georgewfraser/java-language-server";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

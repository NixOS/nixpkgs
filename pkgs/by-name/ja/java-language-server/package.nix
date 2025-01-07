{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk_headless,
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
maven.buildMavenPackage rec {
  pname = "java-language-server";
  version = "0.2.46";

  src = fetchFromGitHub {
    owner = "georgewfraser";
    repo = pname;
    # commit hash is used as owner sometimes forgets to set tags. See https://github.com/georgewfraser/java-language-server/issues/104
    rev = "d7f4303cd233cdad84daffbb871dd4512a2c8da2";
    sha256 = "sha256-BIcfwz+pLQarnK8XBPwDN2nrdvK8xqUo0XFXk8ZV/h0=";
  };

  mvnFetchExtraArgs.dontConfigure = true;
  mvnJdk = jdk_headless;
  mvnHash = "sha256-2uthmSjFQ43N5lgV11DsxuGce+ZptZsmRLTgjDo0M2w=";

  nativeBuildInputs = [
    jdk_headless
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

  meta = with lib; {
    description = "Java language server based on v3.0 of the protocol and implemented using the Java compiler API";
    mainProgram = "java-language-server";
    homepage = "https://github.com/georgewfraser/java-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ hqurve ];
  };
}

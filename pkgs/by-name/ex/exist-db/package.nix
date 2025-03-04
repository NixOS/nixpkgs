{
  fetchFromGitHub,
  git,
  jdk17_headless,
  makeWrapper,
  lib,
  maven,
}:
let
  jdk = jdk17_headless;
  initGit = ''
    git init .
    git config set user.email nobody@localhost
    git config set user.name nobody
    git add README
    git commit -m 'Initial commit'
  '';
in
maven.buildMavenPackage rec {
  pname = "exist-db";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "eXist-db";
    repo = "exist";
    tag = "eXist-${version}";
    hash = "sha256-NdE15sS/U8ae17JUV+YplYnZuzaa0ZCqyxgj8oAq9uk=";
  };

  patches = [
    ./fix-exist-parent.patch
  ];

  mvnHash = "sha256-OdTFbFFosyCz7sxJrMMSIu2oYDR+ipPhePXsTtl+BXI=";
  mvnJdk = jdk;
  mvnFetchExtraArgs = {
    dontConfigure = true;
    preBuild = initGit;
  };

  preBuild = initGit;

  buildOffline = true;

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    git
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv exist-distribution/target/exist-distribution-${version}-dir/{autodeploy,bin,etc,lib} $out

    substituteInPlace "$out/bin/startup.sh" \
      --replace-fail 'jetty.home="$BASEDIR"' 'jetty.home="/var/lib/exist-db/jetty"'
    substituteInPlace "$out/etc/conf.xml" \
      --replace-fail '"../data"' '"/var/lib/exist-db/data"'
    substituteInPlace "$out/etc/log4j2.xml" \
      --replace-fail "\''${log4j:configParentLocation}/../logs" '/var/log/exist-db/logs'

    makeWrapper $out/bin/startup.sh $out/bin/startup \
      --prefix JAVA_HOME : ${jdk17_headless.home}
    makeWrapper $out/bin/shutdown.sh $out/bin/shutdown \
      --prefix JAVA_HOME : ${jdk17_headless.home}

    runHook postInstall
  '';

  meta = {
    description = "Native XML Database and Application Platform";
    longDescription = ''
      High-performance open source native XML (NoSQL document) database
      and application platform built entirely around XML technologies.
    '';
    homepage = "https://exist-db.org/";
    license = lib.licenses.lgpl21;
    platforms = with lib.platforms; unix ++ windows;
    # maintainers = with lib.maintainers; [ pluiedev ];
    # mainProgram = "???";
  };

}

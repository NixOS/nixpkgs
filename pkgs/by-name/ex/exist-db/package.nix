{
  fetchFromGitHub,
  git,
  jdk11_headless,
  makeWrapper,
  lib,
  maven,
}:
let
  jdk = jdk11_headless;
  jre = jdk11_headless;
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
    leaveDotGit = true;
  };

  patches = [
    ./fix-exist-parent.patch
  ];

  mvnHash = "sha256-dp9fxjSS38WITnZEoQU5HKUT/Ntidh8Xv49z1bEP3hE=";
  mvnJdk = jdk;
  mvnFetchExtraArgs = {
    dontConfigure = true;
    buildOffline = false;
    preBuild = initGit;
  };

  buildOffline = false;
  preBuild = initGit;

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    git
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv exist-distribution/target/exist-distribution-${version}-dir/{autodeploy,bin,etc,lib} $out

    substituteInPlace "$out/etc/conf.xml" \
      --replace-fail '"../data"' '"/var/lib/exist-db/data"'
    substituteInPlace "$out/etc/jetty/standard.enabled-jetty-configs" \
      --replace-fail 'jetty-requestlog.xml' '#jetty-requestlog.xml'

    for script in $out/bin/*.sh; do
      makeWrapper $script ''${script%.sh} \
        --prefix JAVA_HOME : ${jre.home}
    done

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
    maintainers = with lib.maintainers; [ afh ];
  };
}

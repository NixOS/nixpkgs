{
  lib,
  maven,
  fetchFromGitHub,
  jdk_headless,
  makeWrapper,
}:
maven.buildMavenPackage rec {
  pname = "openfire";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "igniterealtime";
    repo = "Openfire";
    tag = "v${version}";
    hash = "sha256-VwHDujd3A2f1MtLnbmg6Zp9ITKumg7idQ2RC+gioErU=";
  };

  mvnJdk = jdk_headless;
  mvnHash = "sha256-chUGNP0h9Qpxa3Rfc7awHY3BtLsi0S/Ps3T7p4/QiGs=";

  # some deps require internet for tests
  mvnParameters = "-Dmaven.test.skip";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt}

    cp -R ./distribution/target/distribution-base/* $out/opt
    ln -s $out/opt/lib $out/lib

    for file in openfire.sh openfirectl; do
      wrapProgram $out/opt/bin/$file \
        --set JAVA_HOME ${jdk_headless.home}

      install -Dm555 $out/opt/bin/$file -t $out/bin
    done

    # Used to determine if the Openfire state directory needs updating
    echo ${version} > $out/opt/version

    runHook postInstall
  '';

  meta = {
    description = "XMPP server licensed under the Open Source Apache License";
    homepage = "https://github.com/igniterealtime/Openfire";
    changelog = "https://github.com/igniterealtime/Openfire/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
    mainProgram = "openfire";
  };
}

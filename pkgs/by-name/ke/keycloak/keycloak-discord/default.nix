{
  stdenv,
  maven,
  lib,
  fetchFromGitHub,
}:
maven.buildMavenPackage rec {
  pname = "keycloak-discord";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "iForged";
    repo = "keycloak-discord";
    tag = "v${version}";
    hash = "sha256-xTGXETkE5Ct+h3mYbj3VUoQhi5Wx5oZqz3G1uN0pDns=";
  };

  mvnHash = "sha256-zFsVRFFGrHvTFW6+Y1o2OVFaf34JgqPVv+vMAfkSOJw=";

  installPhase = ''
    runHook preInstall
    install -Dm444 target/keycloak-discord-${version}.jar "$out/keycloak-discord-${version}.jar"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/iForged/keycloak-discord";
    description = "Keycloak Identity Provider extension for Discord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mkg20001
      anish
    ];
  };
}

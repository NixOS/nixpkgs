{
  lib,
  maven,
  fetchFromGitHub,
  jre,
  makeWrapper,
}:
maven.buildMavenPackage {
  pname = "ftl-profile-editor";
  version = "2020-07-10";

  src = fetchFromGitHub {
    owner = "Vhati";
    repo = "ftl-profile-editor";
    rev = "781da4701ad3c91ae48b4f1ae0decf35f8856b98";
    hash = "sha256-xbq7EfOBtDJUNngV5GRWqOlyvA+pMSTRulyiukQN+aI=";
  };

  patches = [ ./java-bump.patch ];

  mvnHash = "sha256-A4PTeytmlt7DTusPihWhuaR3zUopDm6uOnGlXoMx+20=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/FTLProfileEditor
    install -Dm644 target/FTLProfileEditor.jar $out/share/FTLProfileEditor

    makeWrapper ${lib.getExe' jre "java"} $out/bin/FTLProfileEditor \
      --add-flags "-jar $out/share/FTLProfileEditor/FTLProfileEditor.jar"
  '';

  meta = {
    description = "A 3rd party tool to edit user files for FTL.";
    homepage = "https://github.com/Vhati/ftl-profile-editor";
    license = with lib.licenses; gpl2;
    maintainers = with lib.maintainers; [ mib ];
    mainProgram = "FTLProfileEditor";
  };
}

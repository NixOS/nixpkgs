{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:
maven.buildMavenPackage rec {
  pname = "PDF-Over";
  version = "4.4.6";

  src = fetchFromGitHub {
    owner = "a-sit";
    repo = "PDF-Over";
    tag = "pdf-over-${version}";
    hash = "sha256-vThIctiRNO0QvrWDsVzRUKTM5p5I2a/c2lTisgEtC04=";
  };

  mvnHash = "sha256-y//DzR3Y599QcK1O9nczlqYFhsmsw2ommA655wlG948=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    echo oida # authentic Austrian experience (this is important)

    mv pdf-over-build/pdf-over_linux-x86_64.jar pdf-over-build/pdf-over.jar
    install -Dt $out/share/pdf-over pdf-over-build/pdf-over.jar

    makeWrapper ${lib.getExe jre} $out/bin/pdf-over \
      --add-flags "-jar $out/share/pdf-over/pdf-over.jar" \
      --set GDK_BACKEND x11,wayland

    runHook postInstall
  '';

  meta = {
    description = "eIDAS-compliant PDF-signing tool for the Austrian eGovernment platform";
    longDescription = ''
      A simple, yet configurable eIDAS-compliant PDF-signing tool for the Austrian eGovernment platform
      supporting both FIDO2 L2 certified security tokens and smartphone-based
      signing for creating legally valid qualified signatures on PDFs
    '';
    homepage = "https://technology.a-sit.at/en/pdf-over/";
    license = lib.licenses.eupl12;
    mainProgram = "pdf-over";
    maintainers = with lib.maintainers; [ tanja ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "crowdsec-notification-http";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = "crowdsec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/NTlj0kYCOMxShfoKdmouJTiookDjccUj5HFHLPn5HI=";
  };

  vendorHash = "sha256-7587ezh/9C69UzzQGq3DVGBzNEvTzho/zhRlG6g6tkk=";

  buildPhase = ''
    runHook preBuild

    cd cmd/notification-http
    go build -o notification-http

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp notification-http $out/bin/

    mkdir -p $out/share
    cp http.yaml $out/share/

    runHook postInstall
  '';

  meta = {
    homepage = "https://docs.crowdsec.net/docs/local_api/notification_plugins/http/";
    changelog = "https://github.com/crowdsecurity/crowdsec/releases/tag/v${finalAttrs.version}";
    description = "Crowdsec notification HTTP plugin";
    license = lib.licenses.mit;
    mainProgram = "notification-http";
    maintainers = with lib.maintainers; [ akotro ];
  };
})

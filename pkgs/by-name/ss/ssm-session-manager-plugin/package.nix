{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "ssm-session-manager-plugin";
  version = "1.2.633.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "session-manager-plugin";
    rev = version;
    hash = "sha256-dwNCTJOxpothAcJSfch2jkxdgXg6xDd/fDQCQo2Xd+8=";
  };

  vendorHash = null;

  subPackages = [ "src/sessionmanagerplugin-main" ];

  postPatch = ''
    mv vendor{,-old}
    mv vendor-old/src vendor
    rm -r vendor-old
    go mod init github.com/aws/session-manager-plugin
  '';

  preBuild = ''
    echo -n ${lib.escapeShellArg version} > VERSION
    go run src/version/versiongenerator/version-gen.go
  '';

  doCheck = true;
  checkFlags = [ "-skip=TestSetSessionHandlers" ];

  preCheck = ''
    if ! [[ $(go/bin/sessionmanagerplugin-main --version) = ${lib.escapeShellArg version} ]]; then
      echo 'wrong version'
      exit 1
    fi
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 go/bin/sessionmanagerplugin-main "$out/bin/session-manager-plugin"
    runHook postInstall
  '';

  meta = {
    homepage = "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    mainProgram = "session-manager-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ amarshall mbaillie ];
  };
}

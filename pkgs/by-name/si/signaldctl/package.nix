{
  lib,
  buildGoModule,
  fetchFromGitLab,
  gitUpdater,
}:

buildGoModule rec {
  pname = "signaldctl";
  version = "0.6.1";
  src = fetchFromGitLab {
    owner = "signald";
    repo = "signald-go";
    rev = "v${version}";
    hash = "sha256-lMJyr4BPZ8V2f//CUkr7CVQ6o8nRyeLBHMDEyLcHSgQ=";
  };

  vendorHash = "sha256-LGIWAVhDJCg6Ox7U4ZK15K8trjsvSZm4/0jNpIDmG7I=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # install only the binary and not any intermediate artifacts like
    # `generators` which is only used during build
    cp "$GOPATH/bin/signaldctl" $out/bin

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Golang library for communicating with signald";
    mainProgram = "signaldctl";
    homepage = "https://signald.org/signaldctl/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ colinsane ];
  };
}

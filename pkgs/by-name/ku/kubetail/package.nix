{
  stdenv,
  fetchFromGitHub,
  lib,
  installShellFiles,
  makeWrapper,
  kubectl,
}:

stdenv.mkDerivation rec {
  pname = "kubetail";
  version = "1.6.22";

  src = fetchFromGitHub {
    owner = "johanhaleby";
    repo = "kubetail";
    rev = version;
    sha256 = "sha256-iCZoK9is3Zpew0q61ZpG/OK3RLU4Fb6XCh7eVaVrTEY=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    install -Dm755 kubetail "$out/bin/kubetail"
    wrapProgram $out/bin/kubetail --prefix PATH : ${lib.makeBinPath [ kubectl ]}

    installShellCompletion completion/kubetail.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Bash script to tail Kubernetes logs from multiple pods at the same time";
    mainProgram = "kubetail";
    longDescription = ''
      Bash script that enables you to aggregate (tail/follow) logs from
      multiple pods into one stream. This is the same as running "kubectl logs
      -f " but for multiple pods.
    '';
    homepage = "https://github.com/johanhaleby/kubetail";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kalbasit
      qjoly
    ];
    platforms = platforms.all;
  };
}

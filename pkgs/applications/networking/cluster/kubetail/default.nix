{ stdenv, fetchFromGitHub, lib, installShellFiles, makeWrapper, kubectl }:

stdenv.mkDerivation rec {
  pname = "kubetail";
  version = "1.6.18";

  src = fetchFromGitHub {
    owner = "johanhaleby";
    repo = "kubetail";
    rev = version;
    sha256 = "sha256-Gde5thEpMX3h0e1eoC8SeDdkZfa02CmQf3ELLMeEWGU=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  installPhase = ''
    install -Dm755 kubetail "$out/bin/kubetail"
    wrapProgram $out/bin/kubetail --prefix PATH : ${lib.makeBinPath [ kubectl ]}

    installShellCompletion completion/kubetail.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Bash script to tail Kubernetes logs from multiple pods at the same time";
    longDescription = ''
      Bash script that enables you to aggregate (tail/follow) logs from
      multiple pods into one stream. This is the same as running "kubectl logs
      -f " but for multiple pods.
    '';
    homepage = "https://github.com/johanhaleby/kubetail";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit qjoly ];
    platforms = platforms.all;
  };
}

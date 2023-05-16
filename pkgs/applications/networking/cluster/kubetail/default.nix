{ stdenv, fetchFromGitHub, lib, installShellFiles, makeWrapper, kubectl }:

stdenv.mkDerivation rec {
  pname = "kubetail";
<<<<<<< HEAD
  version = "1.6.18";
=======
  version = "1.6.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "johanhaleby";
    repo = "kubetail";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Gde5thEpMX3h0e1eoC8SeDdkZfa02CmQf3ELLMeEWGU=";
=======
    sha256 = "sha256-kkbhhAaiKP01LR7F5JVMgy6Ujji8JDc+Aaho1vft3XQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ kalbasit qjoly ];
=======
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}

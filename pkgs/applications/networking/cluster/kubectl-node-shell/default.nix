{ stdenvNoCC, lib, fetchFromGitHub, bash }:

stdenvNoCC.mkDerivation rec {
  pname = "kubectl-node-shell";
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kvaps";
    repo = "kubectl-node-shell";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+JRHSigjsxuZFQg73wTMWWKtCVXd2mMFqivYGcwYznE=";
=======
    sha256 = "sha256-TCd/VipsUT/h88CevqCLUUjN7wAJKYxxq63IpEF2P1Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  buildInputs = [ bash ];

  installPhase = ''
    runHook preInstall

    install -m755 ./kubectl-node_shell -D $out/bin/kubectl-node_shell

    runHook postInstall
  '';

  meta = with lib; {
    description = "Exec into node via kubectl";
    homepage = "https://github.com/kvaps/kubectl-node-shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ jocelynthode ];
    platforms = platforms.linux;
  };
}

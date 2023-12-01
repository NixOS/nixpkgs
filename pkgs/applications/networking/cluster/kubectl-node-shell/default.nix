{ stdenvNoCC, lib, fetchFromGitHub, bash }:

stdenvNoCC.mkDerivation rec {
  pname = "kubectl-node-shell";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kvaps";
    repo = "kubectl-node-shell";
    rev = "v${version}";
    sha256 = "sha256-+JRHSigjsxuZFQg73wTMWWKtCVXd2mMFqivYGcwYznE=";
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

{ stdenvNoCC, lib, fetchFromGitHub, bash }:

stdenvNoCC.mkDerivation rec {
  pname = "kubectl-node-shell";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "kvaps";
    repo = "kubectl-node-shell";
    rev = "v${version}";
    hash = "sha256-QG1YQH2qd4TBkH42z9htni4llL13sEoBXlih4yc8r4w=";
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
    mainProgram = "kubectl-node_shell";
    homepage = "https://github.com/kvaps/kubectl-node-shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ jocelynthode ];
    platforms = platforms.unix;
  };
}

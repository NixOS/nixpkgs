{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "tektoncd-cli";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tektoncd";
    repo = "cli";
    rev = "v${version}";
    sha256 = "01kcz5pj7hl2wfcqj3kcssj1c589vqqh1r4yc0agb67rm6q7xl06";
  };

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    make bin/tkn
  '';

  installPhase = ''
    install bin/tkn -Dt $out/bin

    mkdir -p "$out/share/man/man1"
    cp docs/man/man1/* "$out/share/man/man1"

    # TODO: Move to enhanced installShellCompletion when merged: PR #83630
    $out/bin/tkn completion bash > tkn.bash
    $out/bin/tkn completion zsh  > _tkn
    installShellCompletion tkn.bash --zsh _tkn
  '';

  meta = with lib; {
    description = "The Tekton Pipelines cli project provides a CLI for interacting with Tekton";
    homepage = "https://tekton.dev";
    longDescription = ''
      The Tekton Pipelines cli project provides a CLI for interacting with Tekton!
      For your convenience, it is recommended that you install the Tekton CLI, tkn, together with the core component of Tekton, Tekton Pipelines.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk mstrangfeld ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

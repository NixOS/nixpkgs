{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "tektoncd-cli";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "tektoncd";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0xb2zlpkh9cwinp6zj2jpv4wlws042ad1fa0wkcnnkh0vjm6mnrl";
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

    installShellCompletion --cmd tkn \
      --bash <($out/bin/tkn completion bash) \
      --fish <($out/bin/tkn completion fish) \
      --zsh <($out/bin/tkn completion zsh)
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

{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "talosctl";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    rev = "v${version}";
    sha256 = "sha256-KvwW5VJ5HDXDxaPssmVnqBWmk3Y1qbu9PcZsd+CLeXE=";
  };

  vendorSha256 = "sha256-i+SUDFOffh4Ky2kawIb3M6M2Han25yYQbWI0wFjZwtU=";

  ldflags = [ "-s" "-w" ];

  GOWORK = "off";

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false; # no tests

  meta = with lib; {
    description = "A CLI for out-of-band management of Kubernetes nodes created by Talos";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}

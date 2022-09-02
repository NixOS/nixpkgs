{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "talosctl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    rev = "v${version}";
    sha256 = "sha256-+cipDqPsBrUw4Q3uDkV76buPWTgtJXnvFsEaqqifTH8=";
  };

  vendorSha256 = "sha256-58XLmJaE3g2KG9e4rOyO1ouBBlCGX96e8AWfr0XVHC4=";

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

  doCheck = false;

  meta = with lib; {
    description = "A CLI for out-of-band management of Kubernetes nodes created by Talos";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}

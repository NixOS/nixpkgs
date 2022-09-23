{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "clusterctl";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api";
    rev = "v${version}";
    sha256 = "sha256-U9U1r74E4ryc8zUb1EogfBT57kfsd89i7DWO05tnQw4=";
  };

  vendorSha256 = "sha256-jM5qU/KaBf+CzKKOuVXjawn/QqwrCjXKaQFFomEPndg=";

  subPackages = [ "cmd/clusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = let t = "sigs.k8s.io/cluster-api/version"; in [
    "-X ${t}.gitMajor=${lib.versions.major version}"
    "-X ${t}.gitMinor=${lib.versions.minor version}"
    "-X ${t}.gitVersion=v${version}"
  ];

  postInstall = ''
    # errors attempting to write config to read-only $HOME
    export HOME=$TMPDIR

    installShellCompletion --cmd clusterctl \
      --bash <($out/bin/clusterctl completion bash) \
      --zsh <($out/bin/clusterctl completion zsh)
  '';

  meta = with lib; {
    description = "Kubernetes cluster API tool";
    homepage = "https://cluster-api.sigs.k8s.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ zowoq ];
  };
}

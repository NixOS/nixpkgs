{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.145.2";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-ipGMGby7qUoFJNc+7+Gq+JaBUdxm19NwhklWsTpslVI=";
  };

  vendorSha256 = "sha256-031Xdr3u35uirDBZhExdh8PMAZa1gfMTC2II8VMbr6Q=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/helmfile/helmfile/pkg/app/version.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd helmfile \
      --bash ./autocomplete/helmfile_bash_autocomplete  \
      --zsh ./autocomplete/helmfile_zsh_autocomplete
  '';

  meta = {
    description = "Declarative spec for deploying Helm charts";
    longDescription = ''
      Declaratively deploy your Kubernetes manifests, Kustomize configs,
      and charts as Helm releases in one shot.
    '';
    homepage = "https://helmfile.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}

{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.138.4";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-Y0/0wC00s7QY7/B6igOoPKXv5TE2P8NoGd9UhfVmLOk=";
  };

  vendorSha256 = "sha256-WlV6moJymQ7VyZXXuViCNN1WP4NzBUszavxpKjQR8to=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/roboll/helmfile/pkg/app/version.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/helmfile \
      --prefix PATH : ${lib.makeBinPath [ kubernetes-helm ]}
  '';

  meta = {
    description = "Deploy Kubernetes Helm charts";
    homepage = "https://github.com/roboll/helmfile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}

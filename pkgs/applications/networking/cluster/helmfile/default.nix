{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.140.0";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-Y1BlvUudxEZ1G893dwYU+R6k2QAYohx4+0yysYaUM0E=";
  };

  vendorSha256 = "sha256-QYI5HxEUNrZKSjk0LlbhjvxXlWCbbLup51Ht3HJDNC8=";

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

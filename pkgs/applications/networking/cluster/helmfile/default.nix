{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.119.0"; in

buildGoModule {
  pname = "helmfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "067hlzp87g36wgxankrmd2nva1v40pa31acq1hh0jxyxp98sfgk1";
  };

  goPackagePath = "github.com/roboll/helmfile";

  vendorSha256 = "11bw10s5wifzw2cy1100hyjv4xv7an7b05lcw6sphwyy56gsp2fy";

  nativeBuildInputs = [ makeWrapper ];

  buildFlagsArray = ''
    -ldflags=
    -X main.Version=${version}
  '';

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
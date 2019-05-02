{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.40.1"; in

buildGoPackage {
  name = "helmfile-${version}";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "02ir10070rpayv9s53anldwjy5ggl268shgf085d188wl6vshaiv";
  };

  goPackagePath = "github.com/roboll/helmfile";

  nativeBuildInputs = [ makeWrapper ];

  buildFlagsArray = ''
    -ldflags=
    -X main.Version=${version}
  '';

  postInstall = ''
    wrapProgram $bin/bin/helmfile \
      --prefix PATH : ${lib.makeBinPath [ kubernetes-helm ]}
  '';


  meta = {
    description = "Deploy Kubernetes Helm charts";
    homepage = https://github.com/roboll/helmfile;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat ];
    platforms = lib.platforms.unix;
  };
}

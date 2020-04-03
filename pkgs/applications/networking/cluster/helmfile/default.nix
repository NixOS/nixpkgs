{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.106.3"; in

buildGoModule {
  pname = "helmfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "0pwkkgdcj9vx6nk574iaqwn074qfpgqd1c44d3kr3xdbac89yfyf";
  };

  goPackagePath = "github.com/roboll/helmfile";

  modSha256 = "1yv2b44qac0rms66v0qg13wsga0di6hwxa4dh2l0b1xvaf75ysay";

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

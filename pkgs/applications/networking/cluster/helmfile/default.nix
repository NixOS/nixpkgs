{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.77.0"; in

buildGoModule {
  pname = "helmfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "0nj8gs7aqkxpj6bd80ks7g34qqa4y53a8sim1znbxs6mb678c2x2";
  };

  goPackagePath = "github.com/roboll/helmfile";

  modSha256 = "1ksz1c4j7mhsbq6ifqab04588d48c9glyhr4d3d4jyvi19qhwx1d";

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
    homepage = https://github.com/roboll/helmfile;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}

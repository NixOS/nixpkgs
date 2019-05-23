{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.64.1"; in

buildGoPackage {
  name = "helmfile-${version}";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "1258c545fv4mcrzaw3z5gxl264fcahigaijgkjd4igh4pl0z0wxk";
  };

  goDeps = ./deps.nix;

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
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}

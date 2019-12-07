{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.85.0"; in

buildGoModule {
  pname = "helmfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "0k1019ddzhhl8kn70ibqf6srlfv92jkc26m78pic5c7ibqyq5fds";
  };

  goPackagePath = "github.com/roboll/helmfile";

  modSha256 = "1npjm3rs32c1rwx8xb9s03jhd156da6p66hpaqccm7b6zxsm32nv";

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

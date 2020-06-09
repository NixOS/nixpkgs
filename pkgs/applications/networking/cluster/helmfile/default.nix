{ lib, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm, ... }:

let version = "0.118.6"; in

buildGoModule {
  pname = "helmfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "0zbvz8kn52c1q4yn8n9z4rrf761h495fhjw72x9q1nh44hr7npwd";
  };

  goPackagePath = "github.com/roboll/helmfile";

  vendorSha256 = "0xj14f0yx7x9ziijd1yka1n6kbmmhbibsk3ppp8cn1pqrwgqk7pr";

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
{ stdenv, buildGoModule, fetchFromGitHub, makeWrapper, kubernetes-helm, Security }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.102.0";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "0v7mhsnhswiqd62wrmkcpzsg9nfi6wvkh9danngs5rqjiz1zffhy";
  };

  modSha256 = "0s7j7jbgr8gdc0s9dnl6zjwkpywqj05xyb7mkcank54kgrz0g5vq";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  buildFlagsArray = ''
    -ldflags=
    -X main.Version=${version}
  '';

  postInstall = ''
    wrapProgram $out/bin/helmfile \
      --prefix PATH : ${stdenv.lib.makeBinPath [ kubernetes-helm ]}
  '';

  meta = with stdenv.lib; {
    description = "Deploy Kubernetes Helm charts";
    homepage = "https://github.com/roboll/helmfile";
    license = licenses.mit;
    maintainers = with maintainers; [ pneumaticat yurrriq ];
    platforms = platforms.unix;
  };
}

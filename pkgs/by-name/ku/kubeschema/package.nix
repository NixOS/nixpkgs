{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  kubectl,
}:
buildGoModule (finalAttrs: {
  pname = "kubeschema";
  version = "0-unstable-2025-01-13";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "imroc";
    repo = "kubeschema";
    rev = "26fd3e32cf1ab1209425bc2adcb8f9f0c4d89d78";
    hash = "sha256-YK9pRuwCEvHzTNn+I/kA7REr3BJJRxU6n4NL7Mq177k=";
  };

  vendorHash = "sha256-sBNNE6SgFx1NAz2B/hsNiUxYAyjFB4UvfKRnl9AxKpY=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/kubeschema \
      --prefix PATH : ${lib.makeBinPath [ kubectl ]}
  '';

  meta = {
    description = "Tool for dumping Kubernetes JSON schemas";
    license = lib.licenses.asl20;
    homepage = "https://github.com/imroc/kubeschema";
    maintainers = with lib.maintainers; [
      fudoge
    ];
    mainProgram = "kubeschema";
  };
})

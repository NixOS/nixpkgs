{
  lib,
  bashNonInteractive,
  fetchFromGitHub,
  kubectl,
  kubernetes-helm,
  makeWrapper,
  python3,
  stdenv,
}:
let
  pythonEnv = python3.withPackages (ps: [
    ps.pyyaml
    ps.diagrams
    ps.pygraphviz
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kube-diagrams";
  version = "0.9.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "philippemerle";
    repo = "KubeDiagrams";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jlJgO10oJ4TFRPIWFVoMMi3jmt/LKVmaSILgZSon/jU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bashNonInteractive
    pythonEnv
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kube-diagrams $out/bin
    cp -r bin/* $out/share/kube-diagrams/
    for prog in kube-diagrams helm-diagrams kubectl-diagrams; do
      chmod +x $out/share/kube-diagrams/$prog
      ln -s $out/share/kube-diagrams/$prog $out/bin/$prog
    done

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/share/kube-diagrams/helm-diagrams \
      --prefix PATH : $out/bin:${lib.makeBinPath [ kubernetes-helm ]}
    wrapProgram $out/share/kube-diagrams/kubectl-diagrams \
      --prefix PATH : $out/bin:${lib.makeBinPath [ kubectl ]}
  '';

  meta = {
    changelog = "https://github.com/philippemerle/KubeDiagrams/releases/tag/v${finalAttrs.version}";
    description = "Generate Kubernetes architecture diagrams from Kubernetes manifest files, kustomization files, Helm charts, helmfiles, and actual cluster state";
    homepage = "https://kubediagrams.lille.inria.fr";
    license = lib.licenses.asl20;
    mainProgram = "kube-diagrams";
    maintainers = with lib.maintainers; [ allsimon ];
    platforms = lib.platforms.all;
  };
})
